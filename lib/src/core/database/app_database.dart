import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/words_table.dart';
import 'tables/word_progress_table.dart';
import 'tables/unimorph_forms_table.dart';
import 'tables/grammar_rules_table.dart';
import '../../features/vocabulary/data/initial_words_seed.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WordsTable, WordProgressTable, UnimorphFormsTable, GrammarRulesTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'lexiflow',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await seedInitialData();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(wordsTable, wordsTable.language);
            await m.addColumn(wordsTable, wordsTable.targetLanguage);
            await m.addColumn(wordsTable, wordsTable.pos);
            await m.addColumn(wordsTable, wordsTable.frequencyScore);
            await m.addColumn(wordsTable, wordsTable.lemma);
            await m.createTable(unimorphFormsTable);
            await m.createTable(grammarRulesTable);
            await seedA1A2Data();
          }
        },
      );

  Future<void> seedA1A2Data() async {
    final existingTerms = (await select(wordsTable).get()).map((w) => w.term.toLowerCase()).toSet();
    final missingSeeds = initialWordsSeed.where((s) => !existingTerms.contains(s.term.toLowerCase())).toList();
    if (missingSeeds.isEmpty) return;

    await batch((batch) {
      for (final seed in missingSeeds) {
        batch.insert(
          wordsTable,
          WordsTableCompanion.insert(
            term: seed.term,
            translation: seed.translation,
            contextSentence: seed.contextSentence,
            category: seed.category,
            level: seed.level,
            language: Value(seed.language),
            targetLanguage: const Value('fr'),
            pos: Value(seed.pos),
            frequencyScore: Value(seed.frequencyScore),
          ),
        );
      }
    });

    final words = await select(wordsTable).get();
    final existingProgressWordIds = (await select(wordProgressTable).get()).map((p) => p.wordId).toSet();

    await batch((batch) {
      for (final word in words) {
        if (!existingProgressWordIds.contains(word.id)) {
          batch.insert(
            wordProgressTable,
            WordProgressTableCompanion.insert(
              wordId: word.id,
              status: 'new',
              step: const Value(0),
              easeFactor: const Value(2.5),
              intervalDays: const Value(0),
              consecutiveSuccesses: const Value(0),
            ),
          );
        }
      }
    });
  }

  Future<void> seedInitialData() async {
    final existingWords = await select(wordsTable).get();
    if (existingWords.isNotEmpty) return;

    await batch((batch) {
      for (final seed in initialWordsSeed) {
        batch.insert(
          wordsTable,
          WordsTableCompanion.insert(
            term: seed.term,
            translation: seed.translation,
            contextSentence: seed.contextSentence,
            category: seed.category,
            level: seed.level,
            language: Value(seed.language),
            targetLanguage: const Value('fr'),
            pos: Value(seed.pos),
            frequencyScore: Value(seed.frequencyScore),
          ),
        );
      }
    });

    final words = await select(wordsTable).get();
    await batch((batch) {
      for (final word in words) {
        batch.insert(
          wordProgressTable,
          WordProgressTableCompanion.insert(
            wordId: word.id,
            status: 'new',
            step: const Value(0),
            easeFactor: const Value(2.5),
            intervalDays: const Value(0),
            consecutiveSuccesses: const Value(0),
          ),
        );
      }
    });
  }

  /// Déduplication : vérifie si un mot existe déjà dans la base locale (insensible à la casse)
  Future<bool> wordExists(String term, {String language = 'en'}) async {
    final query = select(wordsTable)
      ..where((tbl) => tbl.term.lower().equals(term.trim().toLowerCase()) & tbl.language.equals(language));
    final result = await query.getSingleOrNull();
    return result != null;
  }
}
