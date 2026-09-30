import 'word.dart';

abstract class IWordRepository {
  Future<List<Word>> getAllWords();
  Future<Word?> getWordById(int id);
  Future<List<Word>> getWordsByCategory(String category);
  Future<List<String>> getCategories();
}
