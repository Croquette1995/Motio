import '../../vocabulary/domain/i_word_repository.dart';
import '../../vocabulary/domain/word.dart';
import '../data/drift_progress_repository.dart';
import '../domain/study_session.dart';
import '../domain/word_progress.dart';

class SessionSchedulerService {
  final IWordRepository wordRepository;
  final DriftProgressRepository progressRepository;

  static const int defaultMaxSessionCards = 20;
  static const int defaultMaxNewCards = 5;

  SessionSchedulerService({
    required this.wordRepository,
    required this.progressRepository,
  });

  /// Builds a StudySession based on DUE priority + NEW word limit + targetLevel filter.
  Future<StudySession> createSession({
    int maxSessionCards = defaultMaxSessionCards,
    int maxNewCards = defaultMaxNewCards,
    DateTime? asOf,
    String? targetLevel,
  }) async {
    final now = asOf ?? DateTime.now();

    // 1. Fetch DUE cards (nextReviewAt <= now)
    final dueProgresses = await progressRepository.getDueProgresses(
      asOf: now,
      limit: maxSessionCards * 2, // Prendre une marge si filtre de niveau actif
    );

    final List<SessionCard> sessionCards = [];

    for (final prog in dueProgresses) {
      if (sessionCards.length >= maxSessionCards) break;
      final word = await wordRepository.getWordById(prog.wordId);
      if (word != null) {
        if (targetLevel == null || word.level.toUpperCase() == targetLevel.toUpperCase()) {
          sessionCards.add(SessionCard(word: word, progress: prog));
        }
      }
    }

    // 2. Fill with NEW cards if under session limit
    final remainingSlots = maxSessionCards - sessionCards.length;
    if (remainingSlots > 0 && maxNewCards > 0) {
      final newWordsLimit = remainingSlots < maxNewCards ? remainingSlots : maxNewCards;
      final newProgresses = await progressRepository.getNewProgresses(limit: newWordsLimit * 3);

      int newAdded = 0;
      for (final prog in newProgresses) {
        if (newAdded >= newWordsLimit || sessionCards.length >= maxSessionCards) break;
        if (sessionCards.any((c) => c.word.id == prog.wordId)) continue;

        final word = await wordRepository.getWordById(prog.wordId);
        if (word != null) {
          if (targetLevel == null || word.level.toUpperCase() == targetLevel.toUpperCase()) {
            sessionCards.add(SessionCard(word: word, progress: prog));
            newAdded++;
          }
        }
      }
    }

    return StudySession(initialCards: sessionCards);
  }

  /// Pure helper to construct session cards from in-memory collections (ideal for deterministic tests).
  static List<SessionCard> composeSessionList({
    required List<(Word, WordProgress)> dueItems,
    required List<(Word, WordProgress)> newItems,
    int maxSessionCards = defaultMaxSessionCards,
    int maxNewCards = defaultMaxNewCards,
    String? targetLevel,
  }) {
    final List<SessionCard> cards = [];

    final filteredDue = targetLevel == null
        ? dueItems
        : dueItems.where((i) => i.$1.level.toUpperCase() == targetLevel.toUpperCase()).toList();

    final filteredNew = targetLevel == null
        ? newItems
        : newItems.where((i) => i.$1.level.toUpperCase() == targetLevel.toUpperCase()).toList();

    // Priority 1: DUE words
    for (final item in filteredDue) {
      if (cards.length >= maxSessionCards) break;
      cards.add(SessionCard(word: item.$1, progress: item.$2));
    }

    // Priority 2: NEW words up to limit
    final remainingSlots = maxSessionCards - cards.length;
    final newLimit = remainingSlots < maxNewCards ? remainingSlots : maxNewCards;

    int newAdded = 0;
    for (final item in filteredNew) {
      if (newAdded >= newLimit || cards.length >= maxSessionCards) break;
      if (cards.any((c) => c.word.id == item.$1.id)) continue;

      cards.add(SessionCard(word: item.$1, progress: item.$2));
      newAdded++;
    }

    return cards;
  }
}
