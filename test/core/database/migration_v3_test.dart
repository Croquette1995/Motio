import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/features/referentiel/data/drift_referentiel_repository.dart';

void main() {
  test('Drift migration v2 -> v3 preserves existing words and seeds referentiel v1.3', () async {
    final executor = NativeDatabase.memory(
      setup: (rawDb) {
        rawDb.execute('''
          CREATE TABLE words_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            term TEXT NOT NULL,
            translation TEXT NOT NULL,
            context_sentence TEXT NOT NULL,
            category TEXT NOT NULL,
            level TEXT NOT NULL,
            language TEXT NOT NULL DEFAULT 'en',
            target_language TEXT NOT NULL DEFAULT 'fr',
            pos TEXT NOT NULL DEFAULT 'noun',
            frequency_score REAL NOT NULL DEFAULT 4.0,
            lemma TEXT NULL,
            created_at INTEGER NOT NULL DEFAULT 0
          );
        ''');
        rawDb.execute('''
          CREATE TABLE word_progress_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER NOT NULL UNIQUE,
            status TEXT NOT NULL,
            step INTEGER NOT NULL DEFAULT 0,
            ease_factor REAL NOT NULL DEFAULT 2.5,
            interval_days INTEGER NOT NULL DEFAULT 0,
            last_reviewed_at INTEGER NULL,
            next_review_at INTEGER NULL,
            consecutive_successes INTEGER NOT NULL DEFAULT 0
          );
        ''');
        rawDb.execute('''
          CREATE TABLE unimorph_forms_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            word_id INTEGER NOT NULL,
            form TEXT NOT NULL,
            unimorph_tag TEXT NOT NULL,
            label_fr TEXT NOT NULL,
            is_irregular INTEGER NOT NULL DEFAULT 0
          );
        ''');
        rawDb.execute('''
          CREATE TABLE grammar_rules_table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            language TEXT NOT NULL DEFAULT 'en',
            rule_code TEXT NOT NULL,
            title TEXT NOT NULL,
            level TEXT NOT NULL,
            explanation_fr TEXT NOT NULL,
            formula_pattern TEXT NOT NULL
          );
        ''');
        rawDb.execute('''
          INSERT INTO words_table (term, translation, context_sentence, category, level)
          VALUES ('legacy', 'héritage', 'Legacy data stays.', 'Work & Tech', 'B2');
        ''');
        rawDb.execute('PRAGMA user_version = 2;');
      },
    );

    final db = AppDatabase(executor);
    final words = await db.select(db.wordsTable).get();
    expect(words.length, 1);
    expect(words.first.term, 'legacy');

    final refRepo = DriftReferentielRepository(db);
    final langs = await refRepo.getLanguages();
    expect(langs.map((l) => l.code), containsAll(['fr', 'ro', 'de', 'en']));

    await db.close();
  });
}
