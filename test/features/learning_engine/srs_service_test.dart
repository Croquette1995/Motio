import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/features/learning_engine/application/srs_service.dart';
import 'package:lexiflow/src/features/learning_engine/data/drift_progress_repository.dart';
import 'package:lexiflow/src/features/learning_engine/domain/study_session.dart';
import 'package:lexiflow/src/features/learning_engine/domain/word_progress.dart';
import 'package:lexiflow/src/features/vocabulary/domain/word.dart';

void main() {
  late AppDatabase db;
  late DriftProgressRepository progressRepo;
  late SrsService srsService;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    progressRepo = DriftProgressRepository(db);
    srsService = SrsService(progressRepo);
  });

  tearDown(() async {
    await db.close();
  });

  Word createMockWord(int id, String term) {
    return Word(
      id: id,
      term: term,
      translation: 'traduction_$term',
      contextSentence: 'This is $term.',
      category: 'Work & Tech',
      level: 'B1',
      createdAt: DateTime(2026, 1, 1),
    );
  }

  test('Échec d\'un mot le marque immédiatement dû (status: review, nextReviewAt: now)', () async {
    final now = DateTime(2026, 1, 10, 14, 0);
    final word = createMockWord(1, 'deadline');
    const initialProg = WordProgress(wordId: 1, step: 1, status: WordStatus.learning);

    final session = StudySession(
      initialCards: [
        SessionCard(word: word, progress: initialProg),
      ],
    );

    final updated = await srsService.submitAnswer(
      session: session,
      isSuccess: false,
      now: now,
    );

    expect(updated, isNotNull);
    expect(updated!.status, WordStatus.review);
    expect(updated.nextReviewAt, now);
    expect(updated.isDue(now), isTrue);

    // Vérifier la persistance en base
    final fromDb = await progressRepo.getProgressByWordId(1);
    expect(fromDb, isNotNull);
    expect(fromDb!.status, WordStatus.review);
    expect(fromDb.nextReviewAt, now);
    expect(fromDb.isDue(now), isTrue);

    // Vérifier présence dans dueProgresses
    final dueList = await progressRepo.getDueProgresses(asOf: now);
    expect(dueList.length, 1);
    expect(dueList.first.wordId, 1);
  });

  test('Un mot ré-essayé et validé après un échec dans la même session RESTE dû pour révision', () async {
    final now = DateTime(2026, 1, 10, 14, 0);
    final word = createMockWord(1, 'deadline');
    const initialProg = WordProgress(wordId: 1, step: 1, status: WordStatus.learning);

    final session = StudySession(
      initialCards: [
        SessionCard(word: word, progress: initialProg),
      ],
    );

    // 1. Échec initial
    await srsService.submitAnswer(
      session: session,
      isSuccess: false,
      now: now,
    );

    // La carte est replacée en fin de file avec hasFailedOnce: true
    expect(session.remainingCount, 1);
    expect(session.currentCard!.hasFailedOnce, isTrue);

    // 2. Succès lors du second passage dans la même séance
    final completedProg = await srsService.submitAnswer(
      session: session,
      isSuccess: true,
      now: now,
    );

    expect(session.isCompleted, isTrue);
    expect(completedProg, isNotNull);
    // Le mot doit TOUJOURS être dû pour révision (status review, nextReviewAt now)
    expect(completedProg!.status, WordStatus.review);
    expect(completedProg.nextReviewAt, now);
    expect(completedProg.isDue(now), isTrue);

    // En base de données, il doit figurer dans getDueProgresses
    final dueList = await progressRepo.getDueProgresses(asOf: now);
    expect(dueList.length, 1);
    expect(dueList.first.wordId, 1);
  });
}
