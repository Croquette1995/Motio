import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/domain/sentence_quality_filter.dart';
import 'package:lexiflow/src/features/vocabulary/domain/tatoeba_sentence.dart';

TatoebaSentence sentenceOf(
  String textEn, {
  required int id,
  String textFr = 'traduction',
  bool hasAudio = false,
}) {
  return TatoebaSentence(
    id: id,
    textEn: textEn,
    textFr: textFr,
    hasAudio: hasAudio,
  );
}

void main() {
  const filter = SentenceQualityFilter();

  group('SentenceQualityFilter admission (longueur par niveau CECRL)', () {
    test('parameterizes length thresholds by CECRL level', () {
      expect(filter.minWordsFor(CefrLevel.a1), 4);
      expect(filter.maxWordsFor(CefrLevel.a1), 8);
      expect(filter.minWordsFor(CefrLevel.a2), 4);
      expect(filter.maxWordsFor(CefrLevel.a2), 10);
      expect(filter.minWordsFor(CefrLevel.b1), 5);
      expect(filter.maxWordsFor(CefrLevel.b1), 12);
      expect(filter.minWordsFor(CefrLevel.b2), 5);
      expect(filter.maxWordsFor(CefrLevel.b2), 15);
    });

    test('accepts a clean sentence within the level range', () {
      final sentence = sentenceOf('the dog runs very fast', id: 1);
      expect(filter.qualityIssues(sentence, level: CefrLevel.a1), isEmpty);
      expect(filter.isAcceptable(sentence, level: CefrLevel.a1), isTrue);
    });

    test('rejects sentences below the level minimum', () {
      final sentence = sentenceOf('the dog sleeps', id: 2);
      expect(
        filter.qualityIssues(sentence, level: CefrLevel.a1),
        contains(SentenceQualityIssue.tooShort),
      );
    });

    test('rejects sentences above the level maximum but keeps them for B2', () {
      const text = 'now the small dog and the cat run very fast in the garden';
      final a1Issues =
          filter.qualityIssues(sentenceOf(text, id: 3), level: CefrLevel.a1);
      expect(a1Issues, contains(SentenceQualityIssue.tooLong));

      final b2Issues =
          filter.qualityIssues(sentenceOf(text, id: 4), level: CefrLevel.b2);
      expect(b2Issues, isEmpty);
    });

    test('rejects an empty French translation', () {
      final sentence = sentenceOf('the dog runs very fast', id: 5, textFr: '  ');
      expect(
        filter.qualityIssues(sentence, level: CefrLevel.a1),
        contains(SentenceQualityIssue.emptyTranslation),
      );
    });
  });

  group('SentenceQualityFilter mise en forme et mots vides', () {
    test('rejects URLs and HTML tags', () {
      final url = sentenceOf('visit https://spam.example.com today', id: 10);
      final tags = sentenceOf('<b>bold</b> statement here stays', id: 11);
      expect(
        filter.qualityIssues(url, level: CefrLevel.a1),
        contains(SentenceQualityIssue.parasiticFormatting),
      );
      expect(
        filter.qualityIssues(tags, level: CefrLevel.a1),
        contains(SentenceQualityIssue.parasiticFormatting),
      );
    });

    test('rejects excessive uppercase shouting', () {
      final sentence = sentenceOf('THIS SENTENCE SHOUTS VERY LOUDLY', id: 12);
      expect(
        filter.qualityIssues(sentence, level: CefrLevel.a1),
        contains(SentenceQualityIssue.parasiticFormatting),
      );
    });

    test('rejects sentences mostly made of stopwords', () {
      final sentence = sentenceOf('of the and to in on', id: 13);
      expect(
        filter.qualityIssues(sentence, level: CefrLevel.a1),
        contains(SentenceQualityIssue.mostlyStopwords),
      );
    });

    test('tolerates ordinary stopword usage and normal uppercase', () {
      final sentence = sentenceOf('the dog is happy', id: 14);
      expect(filter.stopwordRatio('the dog is happy'), closeTo(0.5, 0.001));
      expect(filter.qualityIssues(sentence, level: CefrLevel.a1), isEmpty);
    });
  });

  group('SentenceQualityFilter score de pertinence', () {
    test('scores the proportion of target-level words (Zipf)', () {
      final a1Heavy = sentenceOf('the cat drinks warm milk', id: 20);
      final noA1 = sentenceOf('station feedback things matter', id: 21);

      expect(
        filter.relevanceScore(a1Heavy, targetLevel: CefrLevel.a1),
        closeTo(0.5, 0.001),
        reason: 'cat et milk sont A1, drinks et warm hors niveau : 2/4',
      );
      expect(
        filter.relevanceScore(noA1, targetLevel: CefrLevel.a1),
        0,
        reason: 'aucun mot du niveau cible',
      );
    });

    test('boosts sentences with audio at equal relevance', () {
      final plain = sentenceOf('the cat drinks warm milk', id: 30);
      final withAudio =
          sentenceOf('the cat drinks warm milk', id: 31, hasAudio: true);

      expect(
        filter.rankScore(withAudio, targetLevel: CefrLevel.a1),
        greaterThan(filter.rankScore(plain, targetLevel: CefrLevel.a1)),
      );
    });

    test('filterAndRank processes the most relevant sentences first', () {
      final low = sentenceOf('station feedback things matter', id: 40);
      final high = sentenceOf('the cat drinks warm milk', id: 41);

      final ranked = filter.filterAndRank([low, high], level: CefrLevel.a1);

      expect(ranked.map((s) => s.id), [41, 40]);
    });
  });

  group('SentenceQualityFilter diversité', () {
    test('deduplicates sentences by id and normalized text', () {
      final batch = [
        sentenceOf('the dog runs fast', id: 50),
        sentenceOf('the dog runs fast', id: 50),
        sentenceOf('The dog runs fast!', id: 51),
        sentenceOf('the cat drinks warm milk', id: 52),
      ];

      final unique = filter.deduplicate(batch);

      expect(unique.map((s) => s.id), [50, 52]);
    });

    test('measures domain distribution on a batch', () {
      final batch = [
        sentenceOf('bread tastes so good', id: 60),
        sentenceOf('the apple pie tastes good', id: 61),
      ];

      final distribution = filter.domainDistribution(batch);

      expect(distribution['Food & Drink'], 2);
      expect(distribution.length, 1);
    });

    test('selectDiverseBatch spreads sentences across the semantic domains',
        () {
      final batch = [
        // 6 phrases Food & Drink (premier mot plein = mot-clé nourriture)
        sentenceOf('bread tastes so good', id: 70),
        sentenceOf('the apple pie tastes good', id: 71),
        sentenceOf('the coffee is very hot now', id: 72),
        sentenceOf('the milk sits in the fridge', id: 73),
        sentenceOf('the restaurant menu looks new', id: 74),
        sentenceOf('the breakfast plate looks great', id: 75),
        // 3 phrases Travel & Places
        sentenceOf('the station platform was busy', id: 76),
        sentenceOf('the train ticket was cheap', id: 77),
        sentenceOf('the hotel room looks small', id: 78),
        // 3 phrases Nature & Animals
        sentenceOf('the dog runs fast outside', id: 79),
        sentenceOf('the cat sleeps in sunshine', id: 80),
        sentenceOf('the bird sings every morning', id: 81),
      ];

      final selected =
          filter.selectDiverseBatch(batch, level: CefrLevel.a1, maxSentences: 9);
      final distribution = filter.domainDistribution(selected);

      expect(selected, hasLength(9));
      expect(distribution.length, 3,
          reason: 'round-robin entre les 3 domaines représentés');
      expect(distribution.values.every((count) => count <= 3), isTrue,
          reason: 'aucun domaine ne monopolise le lot de pré-remplissage');
    });
  });
}
