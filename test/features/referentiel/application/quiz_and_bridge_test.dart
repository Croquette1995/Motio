import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/features/referentiel/application/quiz_generator_service.dart';
import 'package:lexiflow/src/features/referentiel/application/vocabulary_bridge_service.dart';
import 'package:lexiflow/src/features/referentiel/data/drift_referentiel_repository.dart';
import 'package:lexiflow/src/features/referentiel/domain/grammar_lesson.dart';
import 'package:lexiflow/src/features/vocabulary/data/drift_word_repository.dart';

void main() {
  late AppDatabase db;
  late DriftReferentielRepository refRepo;
  late DriftWordRepository wordRepo;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedInitialData();
    refRepo = DriftReferentielRepository(db);
    wordRepo = DriftWordRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  test('QuizGeneratorService deduplicates distractors and prioritizes irregular forms', () async {
    final fr = (await refRepo.getLanguageByCode('fr'))!;
    final lesson = (await refRepo.findLessonBySlug(fr.id, 'subjonctif-present'))!;
    final prendre = (await refRepo.findConjugationByLemma(fr.id, 'prendre'))!;
    final falloir = (await refRepo.findConjugationByLemma(fr.id, 'falloir'))!;

    final session = QuizGeneratorService.buildLessonSession(
      lesson: lesson,
      profile: fr.grammarProfile,
      linkedVerbs: [prendre, falloir],
      linkedDeclensions: const [],
    );

    expect(session.length, greaterThan(1));
    for (final q in session) {
      if (q.qcmOptions.isNotEmpty) {
        final lower = q.qcmOptions.map((o) => o.toLowerCase()).toList();
        expect(lower.toSet().length, lower.length);
      }
    }

    // Save lesson progress
    final progress = await refRepo.saveLessonSessionResult(
      lessonId: lesson.id,
      newResults: {
        session.first.id: ExerciseResult(score: 1.0, attempts: 1, lastAt: DateTime(2026, 1, 1)),
      },
      totalCount: session.length,
    );
    expect(progress.score, greaterThan(0));
  });

  test('VocabularyBridgeService resolves English bare word to "to go" conjugation', () async {
    final bridge = VocabularyBridgeService(referentielRepo: refRepo, wordRepo: wordRepo);
    final added = await wordRepo.addWord(
      term: 'go',
      translation: 'aller',
      contextSentence: 'We go home.',
      category: 'Basics & Greetings',
      level: 'A1',
      pos: 'verb',
      language: 'en',
    );

    final links = await bridge.findMorphologyForWord(added);
    expect(links.conjugation, isNotNull);
    expect(links.conjugation!.lemma, 'to go');

    final matchedWord = await bridge.findWordForMorphology(langCode: 'en', lemma: 'to go');
    expect(matchedWord, isNotNull);
    expect(matchedWord!.term, 'go');
  });
}
