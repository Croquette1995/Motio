import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/word_progress.dart';

extension WordProgressEntryMapper on WordProgressEntry {
  WordProgress toDomain() {
    return WordProgress(
      id: id,
      wordId: wordId,
      status: WordStatus.fromString(status),
      step: step,
      easeFactor: easeFactor,
      intervalDays: intervalDays,
      lastReviewedAt: lastReviewedAt,
      nextReviewAt: nextReviewAt,
      consecutiveSuccesses: consecutiveSuccesses,
    );
  }
}

extension WordProgressDomainMapper on WordProgress {
  WordProgressTableCompanion toCompanion() {
    return WordProgressTableCompanion(
      id: id != null ? Value(id!) : const Value.absent(),
      wordId: Value(wordId),
      status: Value(status.value),
      step: Value(step),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      lastReviewedAt: Value(lastReviewedAt),
      nextReviewAt: Value(nextReviewAt),
      consecutiveSuccesses: Value(consecutiveSuccesses),
    );
  }
}
