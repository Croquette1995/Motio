import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/vocabulary/domain/word.dart';
import 'package:lexiflow/src/features/learning_engine/domain/word_progress.dart';
import 'package:lexiflow/src/features/learning_engine/domain/study_session.dart';
import 'package:lexiflow/src/features/learning_engine/application/session_scheduler_service.dart';

void main() {
  Word createMockWord(int id, String term) {
    return Word(
      id: id,
      term: term,
      translation: 'traduction_$term',
      contextSentence: 'This is an example sentence for $term.',
      category: 'Work & Tech',
      level: 'B1',
      createdAt: DateTime(2026, 1, 1),
    );
  }

  group('SessionSchedulerService - Composition de séance', () {
    test('Priorité aux mots DUE, puis complétion par les mots NEW selon limite', () {
      final now = DateTime(2026, 1, 10);

      final dueItems = List.generate(
        8,
        (i) => (
          createMockWord(i + 1, 'due_word_$i'),
          WordProgress(
            wordId: i + 1,
            step: 2,
            intervalDays: 3,
            status: WordStatus.learning,
            nextReviewAt: now.subtract(const Duration(days: 1)),
          ),
        ),
      );

      final newItems = List.generate(
        10,
        (i) => (
          createMockWord(i + 100, 'new_word_$i'),
          WordProgress(
            wordId: i + 100,
            step: 0,
            status: WordStatus.newWord,
          ),
        ),
      );

      // Session plafond de 15, max 5 nouveaux
      final sessionCards = SessionSchedulerService.composeSessionList(
        dueItems: dueItems,
        newItems: newItems,
        maxSessionCards: 15,
        maxNewCards: 5,
      );

      expect(sessionCards.length, 13); // 8 due + 5 new
      expect(sessionCards.where((c) => c.progress.isDue(now)).length, 8);
      expect(sessionCards.where((c) => c.progress.isNew).length, 5);
    });

    test('Plafond global de cartes respecté', () {
      final now = DateTime(2026, 1, 10);

      final dueItems = List.generate(
        18,
        (i) => (
          createMockWord(i + 1, 'due_word_$i'),
          WordProgress(
            wordId: i + 1,
            step: 1,
            status: WordStatus.learning,
            nextReviewAt: now.subtract(const Duration(hours: 2)),
          ),
        ),
      );

      final newItems = List.generate(
        10,
        (i) => (
          createMockWord(i + 100, 'new_word_$i'),
          const WordProgress(wordId: 100, step: 0),
        ),
      );

      final sessionCards = SessionSchedulerService.composeSessionList(
        dueItems: dueItems,
        newItems: newItems,
        maxSessionCards: 15,
        maxNewCards: 5,
      );

      expect(sessionCards.length, 15);
      expect(sessionCards.where((c) => c.progress.isDue(now)).length, 15);
      // Room was full with DUE words, so 0 new words added
      expect(sessionCards.where((c) => c.progress.isNew).length, 0);
    });
  });

  group('StudySession - Dynamique de file et ré-injection sur échec', () {
    test('Un échec réinjecte la carte en fin de file avec flag hasFailedOnce', () {
      final word1 = createMockWord(1, 'word_1');
      final word2 = createMockWord(2, 'word_2');
      final session = StudySession(
        initialCards: [
          SessionCard(word: word1, progress: const WordProgress(wordId: 1, step: 1)),
          SessionCard(word: word2, progress: const WordProgress(wordId: 2, step: 1)),
        ],
      );

      expect(session.remainingCount, 2);
      expect(session.currentCard!.word.id, 1);

      // Simuler l'échec de la carte 1
      final failedCard = session.remainingQueue.removeFirst();
      session.remainingQueue.addLast(
        failedCard.copyWith(hasFailedOnce: true),
      );

      expect(session.remainingCount, 2);
      // La carte active est maintenant la carte 2
      expect(session.currentCard!.word.id, 2);
      // La carte 1 a été déplacée en fin de file
      expect(session.remainingQueue.last.word.id, 1);
      expect(session.remainingQueue.last.hasFailedOnce, true);
    });

    test('Un succès retire la carte de la file et incrémente les cartes terminées', () {
      final word1 = createMockWord(1, 'word_1');
      final session = StudySession(
        initialCards: [
          SessionCard(word: word1, progress: const WordProgress(wordId: 1, step: 1)),
        ],
      );

      final finishedCard = session.remainingQueue.removeFirst();
      session.completedCards.add(finishedCard);

      expect(session.isCompleted, true);
      expect(session.remainingCount, 0);
      expect(session.completedCount, 1);
      expect(session.progressRatio, 1.0);
    });

    test('Filtrage par targetLevel isole uniquement les cartes du niveau ciblé', () {
      final wordA1 = Word(
        id: 1,
        term: 'water',
        translation: 'eau',
        contextSentence: 'Drink water',
        category: 'Food',
        level: 'A1',
        createdAt: DateTime(2026, 1, 1),
      );
      final wordB2 = Word(
        id: 2,
        term: 'milestone',
        translation: 'jalon',
        contextSentence: 'A milestone',
        category: 'Work',
        level: 'B2',
        createdAt: DateTime(2026, 1, 1),
      );

      final dueItems = [
        (wordA1, const WordProgress(wordId: 1, step: 1)),
        (wordB2, const WordProgress(wordId: 2, step: 2)),
      ];

      final sessionA1 = SessionSchedulerService.composeSessionList(
        dueItems: dueItems,
        newItems: [],
        targetLevel: 'A1',
      );

      expect(sessionA1.length, 1);
      expect(sessionA1.first.word.term, 'water');
      expect(sessionA1.first.word.level, 'A1');
    });
  });
}
