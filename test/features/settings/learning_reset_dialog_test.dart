import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/features/settings/application/user_level_controller.dart';
import 'package:lexiflow/src/features/settings/presentation/learning_reset_dialog.dart';
import 'package:lexiflow/src/features/vocabulary/data/drift_word_repository.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  late AppDatabase testDb;
  late ProviderContainer container;

  Future<String> wordCount(String term) async {
    final rows = await (testDb.select(testDb.wordsTable)
          ..where((tbl) => tbl.term.equals(term)))
        .get();
    return rows.length.toString();
  }

  Widget buildApp() {
    final appRouter = GoRouter(
      initialLocation: '/settings',
      routes: [
        GoRoute(
          path: '/settings',
          builder: (_, __) => Scaffold(
            body: Builder(
              builder: (context) => Center(
                child: FilledButton(
                  onPressed: () => LearningResetDialog.show(context),
                  child: const Text('OUVRIR RESET'),
                ),
              ),
            ),
          ),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (_, __) =>
              const Scaffold(body: Text('Bienvenue dans Motio')),
        ),
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: Text('dashboard')),
        ),
      ],
    );
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(routerConfig: appRouter),
    );
  }

  setUp(() {
    testDb = AppDatabase(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(testDb)],
    );
  });

  tearDown(() async {
    container.dispose();
    await testDb.close();
  });

  testWidgets('annulable à la première étape : rien n\u2019est supprimé', (tester) async {
    await tester.pumpWidget(buildApp());
    await tester.tap(find.text('OUVRIR RESET'));
    await tester.pumpAndSettle();

    expect(find.text('Recommencer ?'), findsOneWidget);
    expect(find.text('CONTINUER'), findsOneWidget);

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();

    expect(find.text('Recommencer ?'), findsNothing);
    expect(await wordCount('hello'), '1');
  });

  testWidgets('étape 2 : récapitulatif, annulation par retour puis validation', (tester) async {
    SharedPreferences.setMockInitialValues({'user_cefr_level': 'B1'});
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('OUVRIR RESET'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('CONTINUER'));
    await tester.pumpAndSettle();

    expect(find.text('Tout recommencer ?'), findsOneWidget);
    expect(find.text('RECOMMENCER'), findsOneWidget);

    await tester.tap(find.text('Retour'));
    await tester.pumpAndSettle();
    expect(find.text('Recommencer ?'), findsOneWidget);

    await tester.tap(find.text('CONTINUER'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('RECOMMENCER'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString(UserLevelNotifier.userLevelKey), isNull);
    expect(prefs.getBool(UserLevelNotifier.levelOnboardedKey), isFalse);
    expect(container.read(userLevelProvider), CefrLevel.a1);
    expect(find.text('Bienvenue dans Motio'), findsOneWidget);
  });

  testWidgets('option décochée : les mots tatoeba sont supprimés, l\u2019onboarding non relancé', (tester) async {
    SharedPreferences.setMockInitialValues({
      UserLevelNotifier.userLevelKey: 'A1',
      UserLevelNotifier.levelOnboardedKey: true,
    });
    final repo = DriftWordRepository(testDb);
    final wordsBefore = (await testDb.select(testDb.wordsTable).get()).length;
    await repo.addWord(
      term: 'flibbertigibbet',
      translation: 'bavard(e)',
      contextSentence: 'My aunt is a real flibbertigibbet.',
      category: 'Daily Life',
      level: 'B2',
    );

    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('OUVRIR RESET'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Relancer l\u2019onboarding'));
    await tester.tap(find.text('Supprimer les mots ajoutés depuis Tatoeba'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('CONTINUER'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('RECOMMENCER'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getBool(UserLevelNotifier.levelOnboardedKey), isTrue);
    expect(find.text('Bienvenue dans Motio'), findsNothing);

    expect((await testDb.select(testDb.wordsTable).get()).length, wordsBefore);
    expect(await testDb.select(testDb.wordProgressTable).get(), isEmpty);
  });

  testWidgets('aucune option : le bouton Continuer est désactivé', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('OUVRIR RESET'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Réinitialiser la progression'));
    await tester.tap(find.text('Relancer l\u2019onboarding'));
    await tester.pumpAndSettle();

    final testerButton = tester.widget<FilledButton>(
      find.widgetWithText(FilledButton, 'CONTINUER'),
    );
    expect(testerButton.onPressed, isNull);
  });
}
