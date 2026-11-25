import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/features/learning_engine/domain/word_progress.dart';
import 'package:lexiflow/src/features/settings/application/level_unlock_controller.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/application/category_progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  ProviderContainer buildContainer() {
    final testDb = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(testDb)],
    );
    addTearDown(() async {
      container.dispose();
      await testDb.close();
    });
    return container;
  }

  group('LevelUnlockController tests', () {
    test('A1 user: lower/active unlocked, higher locked with criterion', () async {
      final container = buildContainer();

      final state = await container.read(levelUnlockStateProvider.future);

      expect(state.userLevel, CefrLevel.a1);
      expect(state.isUnlocked(CefrLevel.a1), isTrue);
      expect(state.isUnlocked(CefrLevel.a2), isFalse);
      expect(state.isUnlocked(CefrLevel.b1), isFalse);
      expect(state.isUnlocked(CefrLevel.b2), isFalse);

      final a1Progress =
          await container.read(levelCategoryProgressProvider(CefrLevel.a1).future);
      final req = state.requirementFor(CefrLevel.a2);
      expect(req, isNotNull);
      expect(req!.prerequisite, CefrLevel.a1);
      expect(req.masteredWords, 0);
      expect(req.requiredWords, (0.7 * a1Progress.totalWords).ceil());
      expect(req.isMet, isFalse);
    });

    test('unlockManually persists the unlock to SharedPreferences', () async {
      final container = buildContainer();

      final notifier = container.read(levelUnlockStateProvider.notifier);
      await notifier.unlockManually(CefrLevel.a2);
      await notifier.unlockManually(CefrLevel.b1);

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getStringList(LevelUnlockService.prefsKey),
        containsAll(['A2', 'B1']),
      );

      final state = await container.read(levelUnlockStateProvider.future);
      expect(state.isUnlocked(CefrLevel.a2), isTrue);
      expect(state.isUnlocked(CefrLevel.b1), isTrue);
      expect(state.isUnlocked(CefrLevel.b2), isFalse);
    });

    test('persisted unlocks survive a fresh container', () async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(LevelUnlockService.prefsKey, ['A2', 'B2']);

      final container = buildContainer();
      final state = await container.read(levelUnlockStateProvider.future);

      expect(state.isUnlocked(CefrLevel.a2), isTrue);
      expect(state.isUnlocked(CefrLevel.b2), isTrue);
    });

    test('criterion met on prerequisite corpus persists the auto-unlock', () async {
      final container = buildContainer();
      final testDb = container.read(appDatabaseProvider);
      final progressRepo = container.read(progressRepositoryProvider);

      final a1Progress =
          await container.read(levelCategoryProgressProvider(CefrLevel.a1).future);
      final requiredWords = (0.7 * a1Progress.totalWords).ceil();

      final wordRows = await (testDb.select(testDb.wordsTable)
            ..where((tbl) => tbl.level.equals('A1')))
          .get();
      expect(wordRows.length, greaterThanOrEqualTo(requiredWords));

      for (final word in wordRows.take(requiredWords)) {
        await progressRepo.saveProgress(
          WordProgress(
            wordId: word.id,
            status: WordStatus.mastered,
            step: 4,
            lastReviewedAt: DateTime.now(),
          ),
        );
      }

      container.invalidate(levelCategoryProgressProvider);
      container.invalidate(levelUnlockStateProvider);
      final state = await container.read(levelUnlockStateProvider.future);

      expect(state.isUnlocked(CefrLevel.a2), isTrue);
      expect(state.isUnlocked(CefrLevel.b1), isFalse);

      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getStringList(LevelUnlockService.prefsKey),
        contains('A2'),
      );
    });
  });
}
