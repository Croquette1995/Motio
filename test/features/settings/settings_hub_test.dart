import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/features/settings/application/level_unlock_controller.dart';
import 'package:lexiflow/src/features/settings/application/user_level_controller.dart';
import 'package:lexiflow/src/features/settings/application/voice_settings_controller.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/settings/domain/voice_settings.dart';
import 'package:lexiflow/src/features/settings/presentation/settings_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ProviderContainer buildContainer() {
    final testDb = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(testDb),
        availableVoicesProvider
            .overrideWith((ref, languageCode) async => <TtsVoice>[]),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await testDb.close();
    });
    return container;
  }

  Widget buildApp(ProviderContainer container) => UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
      );

  testWidgets('le hub expose les sections apprentissage, TTS, données et à propos',
      (tester) async {
    final container = buildContainer();
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildApp(container));
    await tester.pumpAndSettle();

    expect(find.text('APPRENTISSAGE'), findsOneWidget);
    expect(find.text('Langue apprise'), findsOneWidget);
    expect(find.textContaining('RECHOISIR VIA L\u2019ONBOARDING'), findsOneWidget);
    expect(find.text('NIVEAU CECRL ACTIF : A1'), findsOneWidget);
    expect(find.text('VOIX & LECTURE (TTS)'), findsOneWidget);
    expect(find.text('Lecture vocale des phrases'), findsOneWidget);
    expect(find.text('DONNÉES'), findsOneWidget);
    expect(find.text('Recommencer'), findsOneWidget);
    expect(find.text('À PROPOS'), findsOneWidget);
    expect(find.textContaining('version 1.0.0'), findsOneWidget);
    expect(find.textContaining('Tatoeba (CC BY 2.0 FR)'), findsOneWidget);
  });

  testWidgets('le changement de niveau supérieur confirme avant application',
      (tester) async {
    final container = buildContainer();
    await container
        .read(levelUnlockStateProvider.notifier)
        .unlockManually(CefrLevel.a2);

    await tester.pumpWidget(buildApp(container));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Niveau A2 · Élémentaire'));
    await tester.pumpAndSettle();
    expect(find.text('Passer au A2 ?'), findsOneWidget);

    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(container.read(userLevelProvider), CefrLevel.a1);

    await tester.tap(find.text('Niveau A2 · Élémentaire'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Passer au A2'));
    await tester.pumpAndSettle();

    expect(container.read(userLevelProvider), CefrLevel.a2);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('user_cefr_level'), 'A2');
  });

  testWidgets('un niveau verrouillé ouvre le dialogue de déblocage',
      (tester) async {
    final container = buildContainer();
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildApp(container));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Niveau B1 · Intermédiaire'));
    await tester.pumpAndSettle();

    expect(find.text('Niveau B1 verrouillé'), findsOneWidget);
    expect(container.read(userLevelProvider), CefrLevel.a1);
  });

  testWidgets('le bouton Recommencer ouvre le dialogue de confirmation',
      (tester) async {
    final container = buildContainer();
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(buildApp(container));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Recommencer'));
    await tester.pumpAndSettle();

    expect(find.text('Recommencer ?'), findsOneWidget);
    expect(find.widgetWithText(CheckboxListTile, 'Réinitialiser la progression'),
        findsOneWidget);
  });
}
