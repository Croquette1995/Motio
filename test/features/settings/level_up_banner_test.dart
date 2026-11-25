import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/features/settings/application/level_up_suggestion_controller.dart';
import 'package:lexiflow/src/features/settings/application/voice_settings_controller.dart';
import 'package:lexiflow/src/features/settings/domain/voice_settings.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/settings/presentation/level_up_banner.dart';
import 'package:lexiflow/src/features/settings/presentation/settings_screen.dart';
import 'package:lexiflow/src/features/vocabulary/application/category_progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

LevelProgressData fakeProgress(CefrLevel level, int total, int mastered) =>
    LevelProgressData(
      level: level,
      totalWords: total,
      targetWords: level.targetWordCount,
      categories: const [],
      totalMastered: mastered,
      totalReview: 0,
      totalLearning: 0,
      totalNew: total - mastered,
    );

ProviderContainer buildContainer({
  required int mastered,
  List<Override> extraOverrides = const [],
}) {
  final testDb = AppDatabase(NativeDatabase.memory());
  final container = ProviderContainer(
    overrides: [
      appDatabaseProvider.overrideWithValue(testDb),
      levelCategoryProgressProvider(CefrLevel.a1).overrideWith(
            (ref) async => fakeProgress(CefrLevel.a1, 10, mastered),
          ),
      ...extraOverrides,
    ],
  );
  addTearDown(() async {
    container.dispose();
    await testDb.close();
  });
  return container;
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('la bannière apparaît quand les critères de maîtrise sont remplis', (
    tester,
  ) async {
    final container = buildContainer(mastered: 8);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: LevelUpBanner())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('maîtrises 80 % du niveau A1'), findsOneWidget);
    expect(find.text('PASSER AU A2'), findsOneWidget);
    expect(find.text('PLUS TARD'), findsOneWidget);
  });

  testWidgets('la bannière reste absente sous le seuil de maîtrise', (tester) async {
    final container = buildContainer(mastered: 2);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: LevelUpBanner())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('PLUS TARD'), findsNothing);
  });

  testWidgets('refuser replie la bannière', (tester) async {
    final container = buildContainer(mastered: 8);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: LevelUpBanner())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('PLUS TARD'));
    await tester.pumpAndSettle();

    expect(find.text('PASSER AU A2'), findsNothing);
    expect(find.text('PLUS TARD'), findsNothing);
  });

  testWidgets('le refus ne bloque pas le réaffichage manuel depuis les Paramètres', (tester) async {
    final container = buildContainer(
      mastered: 8,
      extraOverrides: [
        availableVoicesProvider
            .overrideWith((ref, languageCode) async => <TtsVoice>[]),
      ],
    );

    await container.read(levelUpSuggestionStateProvider.future);
    await container.read(levelUpSuggestionStateProvider.notifier).decline();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: SettingsScreen())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MONTÉE EN NIVEAU'), findsOneWidget);
    expect(find.text('PASSER AU A2'), findsOneWidget);
  });

  testWidgets('accepter passe au niveau suivant et replie la bannière', (tester) async {
    final container = buildContainer(mastered: 8);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: LevelUpBanner())),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('PASSER AU A2'));
    await tester.pumpAndSettle();

    expect(find.text('PASSER AU A2'), findsNothing);
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('user_cefr_level'), 'A2');
  });
}
