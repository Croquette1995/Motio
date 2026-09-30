import 'dart:collection';
import '../../vocabulary/domain/word.dart';
import 'word_progress.dart';

class SessionCard {
  final Word word;
  final WordProgress progress;
  final bool hasFailedOnce;

  const SessionCard({
    required this.word,
    required this.progress,
    this.hasFailedOnce = false,
  });

  SessionCard copyWith({
    Word? word,
    WordProgress? progress,
    bool? hasFailedOnce,
  }) {
    return SessionCard(
      word: word ?? this.word,
      progress: progress ?? this.progress,
      hasFailedOnce: hasFailedOnce ?? this.hasFailedOnce,
    );
  }
}

class StudySession {
  final Queue<SessionCard> remainingQueue;
  final List<SessionCard> completedCards;
  final int initialCardCount;

  StudySession({
    required List<SessionCard> initialCards,
  })  : remainingQueue = Queue.from(initialCards),
        completedCards = [],
        initialCardCount = initialCards.length;

  bool get isCompleted => remainingQueue.isEmpty;
  int get remainingCount => remainingQueue.length;
  int get completedCount => completedCards.length;
  double get progressRatio =>
      initialCardCount == 0 ? 1.0 : (completedCount / initialCardCount).clamp(0.0, 1.0);

  SessionCard? get currentCard => remainingQueue.isNotEmpty ? remainingQueue.first : null;
}
