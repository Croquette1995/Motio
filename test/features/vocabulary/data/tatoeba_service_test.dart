import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/data/tatoeba_service.dart';
import 'package:lexiflow/src/features/vocabulary/domain/i_word_repository.dart';
import 'package:lexiflow/src/features/vocabulary/domain/word.dart';

class FakeWordRepository implements IWordRepository {
  final Set<String> knownTerms = {'cat', 'house', 'water'};

  @override
  Future<List<Word>> getAllWords() async => [];

  @override
  Future<Word?> getWordById(int id) async => null;

  @override
  Future<List<Word>> getWordsByCategory(String category) async => [];

  @override
  Future<List<Word>> getWordsByLevel(String level) async => [];

  @override
  Future<List<String>> getCategories() async => [];

  @override
  Future<bool> wordExists(String term, {String language = 'en'}) async {
    return knownTerms.contains(term.toLowerCase());
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
    knownTerms.add(term.toLowerCase());
    return Word(
      id: 999,
      term: term,
      translation: translation,
      contextSentence: contextSentence,
      category: category,
      level: level,
      pos: pos,
      language: language,
      frequencyScore: frequencyScore,
      createdAt: DateTime.now(),
    );
  }
}

void main() {
  late TatoebaService service;
  late FakeWordRepository repo;

  setUp(() {
    service = TatoebaService();
    repo = FakeWordRepository();
  });

  group('TatoebaService Unit Tests', () {
    test('extractCandidateTokens strips punctuation and filters English stopwords', () {
      const sentence = 'The cat sleeps on the warm sofa, while it is raining!';
      final tokens = service.extractCandidateTokens(sentence);

      // 'the', 'on', 'while', 'it', 'is' must be filtered out
      expect(tokens, contains('cat'));
      expect(tokens, contains('sleeps'));
      expect(tokens, contains('warm'));
      expect(tokens, contains('sofa'));
      expect(tokens, contains('raining'));

      expect(tokens, isNot(contains('the')));
      expect(tokens, isNot(contains('on')));
      expect(tokens, isNot(contains('it')));
      expect(tokens, isNot(contains('is')));
    });

    test('analyzeSentenceWords detects existing words in local DB and assigns CEFR level', () async {
      const sentence = 'A cat drinks water in the big house and sees an apple.';
      final candidates = await service.analyzeSentenceWords(
        sentence: sentence,
        wordRepository: repo,
      );

      // 'cat', 'water', 'house' are known in FakeWordRepository
      final catCandidate = candidates.firstWhere((c) => c.term == 'cat');
      expect(catCandidate.isAlreadyInDb, isTrue);
      expect(catCandidate.estimatedLevel, equals(CefrLevel.a1));

      final waterCandidate = candidates.firstWhere((c) => c.term == 'water');
      expect(waterCandidate.isAlreadyInDb, isTrue);
      expect(waterCandidate.estimatedLevel, equals(CefrLevel.a1));

      // 'apple' is NOT in DB -> must be flagged as new
      final appleCandidate = candidates.firstWhere((c) => c.term == 'apple');
      expect(appleCandidate.isAlreadyInDb, isFalse);
      expect(appleCandidate.estimatedLevel, equals(CefrLevel.a1));
    });
  });
}
