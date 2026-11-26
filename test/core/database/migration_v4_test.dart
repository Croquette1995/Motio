import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/domain/level_coverage_service.dart';

void main() {
  test('Drift migration v3 -> v4 crée la table de couverture sans perdre les mots', () async {
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
          INSERT INTO words_table (term, translation, context_sentence, category, level)
          VALUES ('legacy', 'héritage', 'Legacy data stays.', 'Work & Tech', 'B2');
        ''');
        rawDb.execute('PRAGMA user_version = 3;');
      },
    );

    final db = AppDatabase(executor);
    expect(db.schemaVersion, 4);

    final words = await db.select(db.wordsTable).get();
    expect(words.length, 1);
    expect(words.first.term, 'legacy');

    final service = LevelCoverageService(db);
    final coverage = await service.refreshCoverage(CefrLevel.b2, language: 'en');
    expect(coverage.wordCount, 1);
    expect(coverage.quota, CefrLevel.b2.levelWordQuota);

    final persisted = await service.getPersistedCoverage(CefrLevel.b2, language: 'en');
    expect(persisted, isNotNull);
    expect(persisted!.wordCount, 1);

    await db.close();
  });
}
