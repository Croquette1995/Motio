import 'package:drift/drift.dart' hide Column;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/features/settings/application/learning_reset_service.dart';
import 'package:lexiflow/src/features/vocabulary/data/drift_word_repository.dart';

void main() {
  test('resetProgress efface la progression SRS et les leçons sans toucher au référentiel', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final service = LearningResetService(db);
    final wordsBefore = await db.select(db.wordsTable).get();
    expect(wordsBefore, isNotEmpty);

    final lesson = (await db.select(db.grammarLessonsTable).get()).first;
    await db.into(db.lessonProgressTable).insert(
          LessonProgressTableCompanion.insert(lessonId: lesson.id, score: const Value(0.8)),
        );

    final summary = await service.reset(
      options: const LearningResetOptions(
        resetProgress: true,
        deleteTatoebaWords: false,
        relaunchOnboarding: false,
      ),
    );

    expect(summary.wordsDeleted, 0);
    expect(summary.lessonProgressRowsDeleted, 1);
    expect(summary.wordProgressRowsDeleted, wordsBefore.length);

    expect(await db.select(db.wordProgressTable).get(), isEmpty);
    expect(await db.select(db.lessonProgressTable).get(), isEmpty);
    expect((await db.select(db.wordsTable).get()).length, wordsBefore.length);
    expect(await db.select(db.grammarLessonsTable).get(), isNotEmpty);
  });

  test('deleteTatoebaWords supprime les mots ajoutés par l\u2019utilisateur mais pas le vocabulaire embarqué', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final repo = DriftWordRepository(db);
    final wordsBefore = await db.select(db.wordsTable).get();
    await repo.addWord(
      term: 'flibbertigibbet',
      translation: 'bavard(e)',
      contextSentence: 'My aunt is a real flibbertigibbet.',
      category: 'Daily Life',
      level: 'B2',
    );

    final service = LearningResetService(db);
    final summary = await service.reset(
      options: const LearningResetOptions(
        resetProgress: false,
        deleteTatoebaWords: true,
        relaunchOnboarding: false,
      ),
    );

    expect(summary.wordsDeleted, 1);
    final termsAfter = (await db.select(db.wordsTable).get())
        .map((w) => w.term)
        .toSet();
    expect(termsAfter.contains('flibbertigibbet'), isFalse);
    expect(termsAfter.length, wordsBefore.length);
    expect(termsAfter.contains('hello'), isTrue);

    final progressWordIds =
        (await db.select(db.wordProgressTable).get()).map((p) => p.wordId).toSet();
    for (final word in await db.select(db.wordsTable).get()) {
      expect(progressWordIds.contains(word.id), isTrue);
    }
  });

  test('reset sans action ne modifie rien', () async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    final service = LearningResetService(db);
    final wordsBefore = await db.select(db.wordsTable).get();
    final progressBefore = await db.select(db.wordProgressTable).get();

    final summary = await service.reset(
      options: const LearningResetOptions(
        resetProgress: false,
        deleteTatoebaWords: false,
        relaunchOnboarding: false,
      ),
    );

    expect(summary.wordsDeleted, 0);
    expect(summary.wordProgressRowsDeleted, 0);
    expect((await db.select(db.wordsTable).get()).length, wordsBefore.length);
    expect((await db.select(db.wordProgressTable).get()).length, progressBefore.length);
  });

  test('learningResetServiceProvider est câblé sur la base de l\u2019app', () {
    final testDb = AppDatabase(NativeDatabase.memory());
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(testDb)],
    );
    addTearDown(() async {
      container.dispose();
      await testDb.close();
    });

    final service = container.read(learningResetServiceProvider);
    expect(service, isA<LearningResetService>());
  });
}
