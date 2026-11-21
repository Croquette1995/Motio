import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/referentiel/domain/text_normalizer.dart';

void main() {
  group('TextNormalizer', () {
    test('normalizes Unicode NFC, Romanian cedillas, apostrophes and spaces', () {
      const decomposed = 'e\u0301'; // e + combining acute
      expect(TextNormalizer.normalize(decomposed), 'é');
      expect(TextNormalizer.normalize('Şcoala şi ţara Ţării'), 'Școala și țara Țării');
      expect(TextNormalizer.normalize('  l’homme \u00A0  d’ici  '), "l'homme d'ici");
    });

    test('evaluateAnswer returns correct, almost (accent), and strict minimal pair wrong', () {
      // Exact match ignoring case and trailing punctuation
      final ok = TextNormalizer.evaluateAnswer(
        input: "  M-AM SPĂLAT! ",
        expected: 'm-am spălat',
        langCode: 'ro',
      );
      expect(ok.status, AnswerStatus.correct);
      expect(ok.status.points, 1.0);

      // Forgotten accent -> almost (0.5)
      final almost = TextNormalizer.evaluateAnswer(
        input: 'frumoasa',
        expected: 'frumoasă',
        langCode: 'ro',
      );
      expect(almost.status, AnswerStatus.almost);
      expect(almost.status.points, 0.5);

      // Strict minimal pair in French (a vs à) -> wrong (0.0), never almost
      final strictPair = TextNormalizer.evaluateAnswer(
        input: 'a',
        expected: 'à',
        langCode: 'fr',
      );
      expect(strictPair.status, AnswerStatus.wrong);
      expect(strictPair.status.points, 0.0);
    });

    test('normalizeVocabularyLookupKey strips particles and articles per language', () {
      expect(TextNormalizer.normalizeVocabularyLookupKey('en', 'to go'), 'go');
      expect(TextNormalizer.normalizeVocabularyLookupKey('ro', 'a se spăla'), 'spăla');
      expect(TextNormalizer.normalizeVocabularyLookupKey('fr', 'se laver'), 'laver');
      expect(TextNormalizer.normalizeVocabularyLookupKey('de', 'der Tisch'), 'tisch');
    });
  });
}
