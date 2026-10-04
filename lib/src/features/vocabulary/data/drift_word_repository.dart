import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/i_word_repository.dart';
import '../domain/word.dart';
import 'word_mapper.dart';

class DriftWordRepository implements IWordRepository {
  final AppDatabase db;

  DriftWordRepository(this.db);

  @override
  Future<List<Word>> getAllWords() async {
    final entries = await db.select(db.wordsTable).get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<Word?> getWordById(int id) async {
    final query = db.select(db.wordsTable)..where((tbl) => tbl.id.equals(id));
    final entry = await query.getSingleOrNull();
    return entry?.toDomain();
  }

  @override
  Future<List<Word>> getWordsByCategory(String category) async {
    final query = db.select(db.wordsTable)
      ..where((tbl) => tbl.category.equals(category));
    final entries = await query.get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<Word>> getWordsByLevel(String level) async {
    final query = db.select(db.wordsTable)
      ..where((tbl) => tbl.level.equals(level));
    final entries = await query.get();
    return entries.map((e) => e.toDomain()).toList();
  }

  @override
  Future<List<String>> getCategories() async {
    final query = db.selectOnly(db.wordsTable, distinct: true)
      ..addColumns([db.wordsTable.category]);
    final rows = await query.get();
    return rows
        .map((row) => row.read(db.wordsTable.category))
        .whereType<String>()
        .toList();
  }

  @override
  Future<bool> wordExists(String term, {String language = 'en'}) async {
    return db.wordExists(term, language: language);
  }

  @override
  Future<Word> addWord({
    required String term,
    required String translation,
    required String contextSentence,
    required String category,
    required String level,
    String pos = 'noun',
    String language = 'en',
    double frequencyScore = 4.0,
    String? lemma,
  }) async {
    final wordId = await db.into(db.wordsTable).insert(
          WordsTableCompanion.insert(
            term: term,
            translation: translation,
            contextSentence: contextSentence,
            category: category,
            level: level,
            language: Value(language),
            targetLanguage: const Value('fr'),
            pos: Value(pos),
            frequencyScore: Value(frequencyScore),
            lemma: Value(lemma),
          ),
        );

    // Initialiser automatiquement la progression SRS pour ce nouveau mot
    await db.into(db.wordProgressTable).insert(
          WordProgressTableCompanion.insert(
            wordId: wordId,
            status: 'new',
            step: const Value(0),
            easeFactor: const Value(2.5),
            intervalDays: const Value(0),
            consecutiveSuccesses: const Value(0),
          ),
        );

    final newEntry = await (db.select(db.wordsTable)..where((tbl) => tbl.id.equals(wordId))).getSingle();
    return newEntry.toDomain();
  }
}
