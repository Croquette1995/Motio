import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/words_table.dart';
import 'tables/word_progress_table.dart';
import '../../features/vocabulary/data/initial_words_seed.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [WordsTable, WordProgressTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'lexiflow');
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await seedInitialData();
        },
      );

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
}
