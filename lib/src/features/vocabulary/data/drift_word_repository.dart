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
  Future<List<String>> getCategories() async {
    final query = db.selectOnly(db.wordsTable, distinct: true)
      ..addColumns([db.wordsTable.category]);
    final rows = await query.get();
    return rows
        .map((row) => row.read(db.wordsTable.category))
        .whereType<String>()
        .toList();
  }
}
