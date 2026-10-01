import 'dart:math' as math;
import 'word_progress.dart';

class SrsCalculator {
  static const double minEaseFactor = 1.3;
  static const double defaultEaseFactor = 2.5;
  static const double easeFactorPenalty = 0.2;

  /// Pure function calculating the updated WordProgress based on success or failure.
  static WordProgress calculateNextReview({
    required WordProgress current,
    required bool isSuccess,
    DateTime? now,
  }) {
    final referenceTime = now ?? DateTime.now();

    if (isSuccess) {
      final int newStep;
      final int newIntervalDays;

      if (current.step == 0) {
        newStep = 1;
        newIntervalDays = 1;
      } else if (current.step == 1) {
        newStep = 2;
        newIntervalDays = 3;
      } else if (current.step == 2) {
        newStep = 3;
        newIntervalDays = 7;
      } else {
        newStep = current.step + 1;
        newIntervalDays = (current.intervalDays * current.easeFactor).round();
      }

      final WordStatus newStatus;
      if (newStep >= 5) {
        newStatus = WordStatus.mastered;
      } else if (newStep >= 3) {
        newStatus = WordStatus.review;
      } else {
        newStatus = WordStatus.learning;
      }

      return current.copyWith(
        step: newStep,
        intervalDays: newIntervalDays,
        easeFactor: current.easeFactor,
        status: newStatus,
        consecutiveSuccesses: current.consecutiveSuccesses + 1,
        lastReviewedAt: referenceTime,
        nextReviewAt: referenceTime.add(Duration(days: newIntervalDays)),
      );
    } else {
      // Failure rules:
      // step = 1, intervalDays = 1, nextReviewAt = now (due immediately for review), easeFactor = max(1.3, easeFactor - 0.2), status = review
      final updatedEaseFactor = math.max(minEaseFactor, current.easeFactor - easeFactorPenalty);
      final roundedEase = double.parse(updatedEaseFactor.toStringAsFixed(2));

      return current.copyWith(
        step: 1,
        intervalDays: 1,
        easeFactor: roundedEase,
        status: WordStatus.review,
        consecutiveSuccesses: 0,
        lastReviewedAt: referenceTime,
        nextReviewAt: referenceTime,
      );
    }
  }
}
