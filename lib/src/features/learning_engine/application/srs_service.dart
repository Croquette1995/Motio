import '../data/drift_progress_repository.dart';
import '../domain/srs_calculator.dart';
import '../domain/study_session.dart';
import '../domain/word_progress.dart';

class SrsService {
  final DriftProgressRepository progressRepository;

  SrsService(this.progressRepository);

  /// Processes the user's answer on the current session card.
  /// - On Success:
  ///   - If card has not failed in this session, calculates standard SRS progression.
  ///   - If card failed previously in this session, completes it from current session queue
  ///     while keeping the J+1 review schedule established during failure.
  ///   - Removes card from remaining queue and adds to completed list.
  /// - On Failure:
  ///   - Applies failure penalty (step = 1, interval = 1 day, reduced easeFactor).
  ///   - Saves to DB (J+1 review date).
  ///   - Removes from front and moves to the end of the session queue for immediate reinforcement.
  Future<WordProgress?> submitAnswer({
    required StudySession session,
    required bool isSuccess,
    DateTime? now,
  }) async {
    if (session.isCompleted) return null;

    final currentCard = session.currentCard;
    if (currentCard == null) return null;

    final referenceTime = now ?? DateTime.now();

    if (isSuccess) {
      // Dequeue current card
      session.remainingQueue.removeFirst();

      final WordProgress updatedProgress;
      if (currentCard.hasFailedOnce) {
        // Re-validated after failure in this session:
        // Keep it due for review (status: review, nextReviewAt: referenceTime)
        // so the learner sees it as "À réviser" and it is prioritized in subsequent sessions.
        updatedProgress = currentCard.progress.copyWith(
          nextReviewAt: referenceTime,
          lastReviewedAt: referenceTime,
          status: WordStatus.review,
        );
        await progressRepository.saveProgress(updatedProgress);
      } else {
        // Standard success progression
        updatedProgress = SrsCalculator.calculateNextReview(
          current: currentCard.progress,
          isSuccess: true,
          now: referenceTime,
        );
        await progressRepository.saveProgress(updatedProgress);
      }

      session.completedCards.add(currentCard.copyWith(progress: updatedProgress));
      return updatedProgress;
    } else {
      // Failure
      session.remainingQueue.removeFirst();

      final updatedProgress = SrsCalculator.calculateNextReview(
        current: currentCard.progress,
        isSuccess: false,
        now: referenceTime,
      );

      // Persist failure to DB (interval J+1)
      await progressRepository.saveProgress(updatedProgress);

      // Re-queue at the end for immediate active recall reinforcement
      final reQueuedCard = currentCard.copyWith(
        progress: updatedProgress,
        hasFailedOnce: true,
      );
      session.remainingQueue.addLast(reQueuedCard);

      return updatedProgress;
    }
  }
}
