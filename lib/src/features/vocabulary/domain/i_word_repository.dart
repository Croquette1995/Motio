import 'word.dart';

abstract class IWordRepository {
  Future<List<Word>> getAllWords();
  Future<Word?> getWordById(int id);
  Future<List<Word>> getWordsByCategory(String category);
  Future<List<Word>> getWordsByLevel(String level);
  Future<List<String>> getCategories();
  Future<bool> wordExists(String term, {String language = 'en'});
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
  });
}
