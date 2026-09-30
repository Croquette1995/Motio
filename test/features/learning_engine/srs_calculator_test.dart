import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/learning_engine/domain/srs_calculator.dart';
import 'package:lexiflow/src/features/learning_engine/domain/word_progress.dart';

void main() {
  group('SrsCalculator - Progression de succès', () {
    final now = DateTime(2026, 1, 1, 10, 0);

    test('Nouveau mot (step 0) -> step 1, intervalle 1 jour, statut learning', () {
      const initial = WordProgress(wordId: 1, step: 0, easeFactor: 2.5);
      final next = SrsCalculator.calculateNextReview(
        current: initial,
        isSuccess: true,
        now: now,
      );

      expect(next.step, 1);
      expect(next.intervalDays, 1);
      expect(next.status, WordStatus.learning);
      expect(next.consecutiveSuccesses, 1);
      expect(next.lastReviewedAt, now);
      expect(next.nextReviewAt, now.add(const Duration(days: 1)));
    });

    test('Step 1 -> step 2, intervalle 3 jours, statut learning', () {
      const initial = WordProgress(
        wordId: 1,
        step: 1,
        intervalDays: 1,
        easeFactor: 2.5,
        consecutiveSuccesses: 1,
      );
      final next = SrsCalculator.calculateNextReview(
        current: initial,
        isSuccess: true,
        now: now,
      );

      expect(next.step, 2);
      expect(next.intervalDays, 3);
      expect(next.status, WordStatus.learning);
      expect(next.consecutiveSuccesses, 2);
      expect(next.nextReviewAt, now.add(const Duration(days: 3)));
    });

    test('Step 2 -> step 3, intervalle 7 jours, statut review', () {
      const initial = WordProgress(
        wordId: 1,
        step: 2,
        intervalDays: 3,
        easeFactor: 2.5,
        consecutiveSuccesses: 2,
      );
      final next = SrsCalculator.calculateNextReview(
        current: initial,
        isSuccess: true,
        now: now,
      );

      expect(next.step, 3);
      expect(next.intervalDays, 7);
      expect(next.status, WordStatus.review);
      expect(next.consecutiveSuccesses, 3);
      expect(next.nextReviewAt, now.add(const Duration(days: 7)));
    });

    test('Step 3 -> step 4, intervalle = round(7 * 2.5) = 18 jours', () {
      const initial = WordProgress(
        wordId: 1,
        step: 3,
        intervalDays: 7,
        easeFactor: 2.5,
        consecutiveSuccesses: 3,
      );
      final next = SrsCalculator.calculateNextReview(
        current: initial,
        isSuccess: true,
        now: now,
      );

      expect(next.step, 4);
      expect(next.intervalDays, 18);
      expect(next.status, WordStatus.review);
      expect(next.consecutiveSuccesses, 4);
      expect(next.nextReviewAt, now.add(const Duration(days: 18)));
    });

    test('Step 4 -> step 5, statut passe à mastered (seuil >= 5)', () {
      const initial = WordProgress(
        wordId: 1,
        step: 4,
        intervalDays: 18,
        easeFactor: 2.5,
        consecutiveSuccesses: 4,
      );
      final next = SrsCalculator.calculateNextReview(
        current: initial,
        isSuccess: true,
        now: now,
      );

      expect(next.step, 5);
      expect(next.status, WordStatus.mastered);
      expect(next.consecutiveSuccesses, 5);
    });
  });

  group('SrsCalculator - Gestion des échecs', () {
    final now = DateTime(2026, 1, 1, 10, 0);

    test('Échec réinitialise à step 1, intervalle 1 jour, et pénalise easeFactor', () {
      const initial = WordProgress(
        wordId: 1,
        step: 4,
        intervalDays: 18,
        easeFactor: 2.5,
        consecutiveSuccesses: 4,
        status: WordStatus.review,
      );
      final next = SrsCalculator.calculateNextReview(
        current: initial,
        isSuccess: false,
        now: now,
      );

      expect(next.step, 1);
      expect(next.intervalDays, 1);
      expect(next.easeFactor, 2.3);
      expect(next.status, WordStatus.learning);
      expect(next.consecutiveSuccesses, 0);
      expect(next.nextReviewAt, now.add(const Duration(days: 1)));
    });

    test('EaseFactor ne descend jamais sous le plancher de 1.3', () {
      const initial = WordProgress(
        wordId: 1,
        step: 2,
        intervalDays: 3,
        easeFactor: 1.4,
        consecutiveSuccesses: 2,
      );
      final next = SrsCalculator.calculateNextReview(
        current: initial,
        isSuccess: false,
        now: now,
      );

      expect(next.easeFactor, 1.3);
    });
  });
}
