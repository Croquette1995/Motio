import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/settings/application/level_unlock_controller.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/application/category_progress_service.dart';

LevelProgressData _progress(CefrLevel level, int totalWords, int totalMastered) {
  return LevelProgressData(
    level: level,
    totalWords: totalWords,
    targetWords: level.targetWordCount,
    categories: const [],
    totalMastered: totalMastered,
    totalReview: 0,
    totalLearning: 0,
    totalNew: totalWords - totalMastered,
  );
}

void main() {
  group('LevelUnlockService.isUnlocked', () {
    test('lower and active levels are always unlocked', () {
      expect(
        LevelUnlockService.isUnlocked(
          level: CefrLevel.a1,
          userLevel: CefrLevel.b1,
          unlockedLevels: const {},
        ),
        isTrue,
      );
      expect(
        LevelUnlockService.isUnlocked(
          level: CefrLevel.b1,
          userLevel: CefrLevel.b1,
          unlockedLevels: const {},
        ),
        isTrue,
      );
    });

    test('higher levels are locked unless persisted unlock', () {
      expect(
        LevelUnlockService.isUnlocked(
          level: CefrLevel.a2,
          userLevel: CefrLevel.a1,
          unlockedLevels: const {},
        ),
        isFalse,
      );
      expect(
        LevelUnlockService.isUnlocked(
          level: CefrLevel.a2,
          userLevel: CefrLevel.a1,
          unlockedLevels: const {CefrLevel.a2},
        ),
        isTrue,
      );
    });
  });

  group('LevelUnlockService.requirementFor', () {
    test('A1 has no prerequisite requirement', () {
      final req = LevelUnlockService.requirementFor(CefrLevel.a1, {});
      expect(req, isNull);
    });

    test('requirement is measured on the prerequisite corpus at 70%', () {
      final progress = {
        CefrLevel.a1: _progress(CefrLevel.a1, 20, 5),
      };

      final req = LevelUnlockService.requirementFor(CefrLevel.a2, progress);
      expect(req, isNotNull);
      expect(req!.prerequisite, CefrLevel.a1);
      expect(req.requiredWords, 14); // ceil(0.7 * 20)
      expect(req.masteredWords, 5);
      expect(req.isMet, isFalse);
      expect(req.progress, closeTo(5 / 14, 0.0001));
      expect(
        req.message(target: CefrLevel.a2),
        contains('Maîtrisez 70 % du corpus A1 (5/14 mots)'),
      );
    });

    test('requirement is met exactly at the threshold', () {
      final progress = {
        CefrLevel.a1: _progress(CefrLevel.a1, 20, 14),
      };

      final req = LevelUnlockService.requirementFor(CefrLevel.a2, progress)!;
      expect(req.isMet, isTrue);
      expect(req.progress, 1.0);
    });

    test('prerequisite chains one level down (B2 requires B1)', () {
      final progress = {
        CefrLevel.b1: _progress(CefrLevel.b1, 10, 0),
      };

      final req = LevelUnlockService.requirementFor(CefrLevel.b2, progress)!;
      expect(req.prerequisite, CefrLevel.b1);
      expect(req.requiredWords, 7);
    });
  });
}
