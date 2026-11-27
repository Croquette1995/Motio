import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/domain/sentence_quality_filter.dart';
import 'package:lexiflow/src/features/vocabulary/domain/word_frequency_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late WordFrequencyService frequencyService;

  setUpAll(() async {
    await WordFrequencyService.preloadLanguage('en');
  });

  setUp(() {
    frequencyService = const WordFrequencyService();
  });

  group('WordFrequencyService Unit Tests', () {
    test('A1 core words return Zipf >= 5.1 and CefrLevel.a1', () {
      expect(frequencyService.determineLevel('water'), equals(CefrLevel.a1));
      expect(frequencyService.determineLevel('eat'), equals(CefrLevel.a1));
      expect(frequencyService.determineLevel('house'), equals(CefrLevel.a1));
      expect(frequencyService.determineLevel('book'), equals(CefrLevel.a1));
      expect(frequencyService.determineLevel('money'), equals(CefrLevel.a1));
      expect(frequencyService.getFrequencyScore('water'), greaterThanOrEqualTo(5.1));
    });

    test('A2 words return 4.5 <= Zipf < 5.1 and CefrLevel.a2', () {
      expect(frequencyService.determineLevel('travel'), equals(CefrLevel.a2));
      expect(frequencyService.determineLevel('weather'), equals(CefrLevel.a2));
      expect(frequencyService.determineLevel('kitchen'), equals(CefrLevel.a2));
      expect(frequencyService.determineLevel('restaurant'), equals(CefrLevel.a2));
      expect(frequencyService.determineLevel('station'), equals(CefrLevel.a2));
    });

    test('B1 words return 3.5 <= Zipf < 4.5 and CefrLevel.b1', () {
      expect(frequencyService.determineLevel('deadline'), equals(CefrLevel.b1));
      expect(frequencyService.determineLevel('feedback'), equals(CefrLevel.b1));
      expect(frequencyService.determineLevel('consensus'), equals(CefrLevel.b1));
      expect(frequencyService.determineLevel('bias'), equals(CefrLevel.b1));
    });

    test('B2 words return Zipf < 3.5 and CefrLevel.b2', () {
      // Hors du top 10 000 de la wordlist (coupure ~3.8) : la carte curated
      // anglaise reste le référentiel des mots spécialisés.
      expect(frequencyService.determineLevel('troubleshoot'), equals(CefrLevel.b2));
      expect(frequencyService.determineLevel('streamline'), equals(CefrLevel.b2));
      expect(frequencyService.determineLevel('itinerary'), equals(CefrLevel.b2));
      expect(frequencyService.determineLevel('workflow'), equals(CefrLevel.b2));
    });

    test('Heuristic fallback works gracefully on unlisted words', () {
      // Mot court non répertorié : 5.0, plafonné sous le seuil A1 (5.1) :
      // le fallback par longueur ne produit jamais d'A1 (Issue 31).
      final shortLevel = frequencyService.determineLevel('zxy');
      expect(shortLevel, equals(CefrLevel.a2));

      // Medium word
      final medLevel = frequencyService.determineLevel('hypothetic');
      expect(medLevel, equals(CefrLevel.b1));

      // Very long word
      final longLevel = frequencyService.determineLevel('counterproductive');
      expect(longLevel, equals(CefrLevel.b2));
    });
  });

  group('WordFrequencyService embedded wordlist (Issue 31)', () {
    test('drives Zipf from the embedded English wordlist before the curated map', () {
      // Valeurs wordfreq réelles (5.52 / 5.1), pas les valeurs curated (5.8 / 5.5).
      expect(frequencyService.getFrequencyScore('water'), 5.52);
      expect(frequencyService.getFrequencyScore('dog'), 5.1);
      expect(frequencyService.determineLevel('dog'), CefrLevel.a1,
          reason: 'dog (Zipf 5.1) atteint exactement le seuil A1');
    });

    test('keeps the curated map as a fallback when the wordlist is absent', () {
      // Langue sans wordlist embarquée : cache vide, la carte curated anglaise
      // reste consultée comme override de secours.
      expect(frequencyService.getFrequencyScore('water', language: 'xx'), 5.8);
    });

    test('embedding covers the 10 v1 languages with ~10k entries each', () async {
      const languages = [
        'en', 'fr', 'de', 'es', 'it', 'pt', 'nl', 'sv', 'pl', 'ro',
      ];
      for (final language in languages) {
        await WordFrequencyService.preloadLanguage(language);
        expect(WordFrequencyService.wordlistSize(language),
            greaterThanOrEqualTo(9000),
            reason: 'wordlist_$language.json embarquée et complète');
      }
      expect(WordFrequencyService.wordlistSize('zz'), 0,
          reason: 'langue sans wordlist : cache vide, fallback gracieux');
    });

    test('extractable English A1 pool reaches the 500-word quota', () {
      final stopwords = SentenceQualityFilter.englishStopwords;
      final pool = frequencyService
          .wordsAtLevel(CefrLevel.a1, language: 'en')
          .where((w) => w.length >= 2 && !w.contains(RegExp(r"[^a-z'’]")))
          .where((w) => !stopwords.contains(w.replaceAll(RegExp(r"[’]"), "'")))
          .toList();

      expect(pool.length, greaterThanOrEqualTo(500),
          reason: 'le pool A1 extractible doit couvrir le quota de 500 mots '
              '(73 mots avant la wordlist embarquée)');
    });

    test('wordsAtLevel respects the level Zipf window', () {
      final a1 = frequencyService.wordsAtLevel(CefrLevel.a1, language: 'en');
      expect(a1, contains('the'),
          reason: 'A1 : pas de borne haute, les hyper-fréquents sont inclus');
      final a2 = frequencyService.wordsAtLevel(CefrLevel.a2, language: 'en');
      expect(a2, contains('travel'));
      expect(a2, isNot(contains('water')));
    });
  });
}
