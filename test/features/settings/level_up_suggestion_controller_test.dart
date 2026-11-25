import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/features/settings/application/level_unlock_controller.dart';
import 'package:lexiflow/src/features/settings/application/level_up_suggestion_controller.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
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

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group('LevelUpSuggestionService.evaluate', () {
    test('null au dernier niveau (B2)', () {
      final suggestion = LevelUpSuggestionService.evaluate(
        userLevel: CefrLevel.b2,
        masteredWords: 100,
        totalWords: 100,
      );
      expect(suggestion, isNull);
    });

    test('null avec un corpus vide', () {
      final suggestion = LevelUpSuggestionService.evaluate(
        userLevel: CefrLevel.a1,
        masteredWords: 0,
        totalWords: 0,
      );
      expect(suggestion, isNull);
    });

    test('null sous le seuil de maîtrise de 70 %', () {
      final suggestion = LevelUpSuggestionService.evaluate(
        userLevel: CefrLevel.a1,
        masteredWords: 6,
        totalWords: 10,
      );
      expect(suggestion, isNull);
    });

    test('suggestion au seuil de maîtrise, mots requis proportionnels au corpus', () {
      final suggestion = LevelUpSuggestionService.evaluate(
        userLevel: CefrLevel.a1,
        masteredWords: 8,
        totalWords: 10,
      );
      expect(suggestion, isNotNull);
      expect(suggestion!.targetLevel, CefrLevel.a2);
      expect(suggestion.requiredWords, 7);
      expect(suggestion.masteredWords, 8);
      expect(suggestion.message(), contains('maîtrises 80 % du niveau A1'));
    });
  });

  group('LevelUpSuggestionNotifier', () {
    ProviderContainer buildContainer({required int mastered}) {
      final testDb = AppDatabase(NativeDatabase.memory());
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
          levelCategoryProgressProvider(CefrLevel.a1).overrideWith(
                (ref) async => fakeProgress(CefrLevel.a1, 10, mastered),
              ),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await testDb.close();
      });
      return container;
    }

    test('critères atteints → suggestion et bannière visibles', () async {
      final container = buildContainer(mastered: 8);

      final state = await container.read(levelUpSuggestionStateProvider.future);

      expect(state.suggestion, isNotNull);
      expect(state.suggestion!.targetLevel, CefrLevel.a2);
      expect(state.isBannerVisible, isTrue);
    });

    test('critères non atteints → pas de suggestion', () async {
      final container = buildContainer(mastered: 2);

      final state = await container.read(levelUpSuggestionStateProvider.future);

      expect(state.suggestion, isNull);
      expect(state.isBannerVisible, isFalse);
    });

    test('refus → bannière repliée mais suggestion conservée pour le réaffichage Paramètres', () async {
      final container = buildContainer(mastered: 8);
      final notifier = container.read(levelUpSuggestionStateProvider.notifier);
      await container.read(levelUpSuggestionStateProvider.future);

      await notifier.decline();

      final state = container.read(levelUpSuggestionDisplayProvider);
      expect(state.isBannerVisible, isFalse);
      expect(
        state.suggestion,
        isNotNull,
        reason: 'La section Paramètres reste disponible après un refus.',
      );
      final prefs = await SharedPreferences.getInstance();
      expect(
        prefs.getStringList(LevelUpSuggestionService.declinedPrefsKey),
        contains('A2'),
      );
    });

    test('acceptation → niveau suivant actif, déblocage persisté, historique des niveaux couverts', () async {
      final container = buildContainer(mastered: 8);
      final notifier = container.read(levelUpSuggestionStateProvider.notifier);
      await container.read(levelUpSuggestionStateProvider.future);

      await notifier.accept();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_cefr_level'), 'A2');
      expect(prefs.getStringList(LevelUnlockService.prefsKey), contains('A2'));
      expect(
        prefs.getStringList(LevelUpSuggestionService.coveredPrefsKey),
        contains('A1'),
      );

      final state = await container.read(levelUpSuggestionStateProvider.future);
      expect(state.coveredLevels, contains(CefrLevel.a1));
      expect(
        state.suggestion,
        isNull,
        reason: 'A2 tout juste entamé : pas de nouvelle suggestion.',
      );
      expect(state.isBannerVisible, isFalse);
    });
  });
}
