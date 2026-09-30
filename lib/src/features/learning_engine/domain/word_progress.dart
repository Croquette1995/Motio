enum WordStatus {
  newWord('new'),
  learning('learning'),
  review('review'),
  mastered('mastered');

  final String value;
  const WordStatus(this.value);

  static WordStatus fromString(String val) {
    return WordStatus.values.firstWhere(
      (e) => e.value == val,
      orElse: () => WordStatus.newWord,
    );
  }
}

class WordProgress {
  final int? id;
  final int wordId;
  final WordStatus status;
  final int step;
  final double easeFactor;
  final int intervalDays;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;
  final int consecutiveSuccesses;

  const WordProgress({
    this.id,
    required this.wordId,
    this.status = WordStatus.newWord,
    this.step = 0,
    this.easeFactor = 2.5,
    this.intervalDays = 0,
    this.lastReviewedAt,
    this.nextReviewAt,
    this.consecutiveSuccesses = 0,
  });

  bool isDue([DateTime? now]) {
    final reference = now ?? DateTime.now();
    if (nextReviewAt == null) return false;
    return nextReviewAt!.isBefore(reference) || nextReviewAt!.isAtSameMomentAs(reference);
  }

  bool get isNew => status == WordStatus.newWord || step == 0;

  WordProgress copyWith({
    int? id,
    int? wordId,
    WordStatus? status,
    int? step,
    double? easeFactor,
    int? intervalDays,
    DateTime? lastReviewedAt,
    DateTime? nextReviewAt,
    int? consecutiveSuccesses,
  }) {
    return WordProgress(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      status: status ?? this.status,
      step: step ?? this.step,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      consecutiveSuccesses: consecutiveSuccesses ?? this.consecutiveSuccesses,
    );
  }
}
