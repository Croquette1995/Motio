import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/data/tatoeba_service.dart';
import 'package:lexiflow/src/features/vocabulary/domain/lemmatizer.dart';
import 'package:lexiflow/src/features/vocabulary/domain/word_frequency_service.dart';

void main() {
  group('lemmatize — anglais (Issue 32)', () {
    test('inflections from the acceptance list resolve to their lemma', () {
      expect(lemmatize('dogs'), 'dog');
      expect(lemmatize('went'), 'go');
      expect(lemmatize('eating'), 'eat');
      expect(lemmatize('children'), 'child');
      expect(lemmatize('better'), 'good');
    });

    test('no false lemma on invariable or short words', () {
      expect(lemmatize('be'), 'be');
      expect(lemmatize('the'), 'the');
      expect(lemmatize('is'), 'is');
      expect(lemmatize('to'), 'to');
      expect(lemmatize('it'), 'it');
      expect(lemmatize('this'), 'this');
      expect(lemmatize('bus'), 'bus');
      expect(lemmatize('less'), 'less');
      expect(lemmatize('press'), 'press');
    });

    test('regular suffix rules', () {
      expect(lemmatize("dog's"), 'dog');
      expect(lemmatize('cats'), 'cat');
      expect(lemmatize('boxes'), 'box');
      expect(lemmatize('watches'), 'watch');
      expect(lemmatize('studies'), 'study');
      expect(lemmatize('running'), 'run');
      expect(lemmatize('stopped'), 'stop');
      expect(lemmatize('wanted'), 'want');
    });

    test('is a pure function (no transformation of unknown tokens)', () {
      expect(lemmatize('xylophone'), 'xylophone');
      expect(lemmatize('Xylophone'), 'xylophone');
    });
  });

  group('lemmatize — langues romanes et germaniques (règles minimales)', () {
    test('fr : pluriels en -s', () {
      expect(lemmatize('chats', language: 'fr'), 'chat');
      expect(lemmatize('tables', language: 'fr'), 'table');
    });

    test('es : pluriels -s/-es', () {
      expect(lemmatize('gatos', language: 'es'), 'gato');
      expect(lemmatize('árboles', language: 'es'), 'árbol');
    });

    test('it : pluriels -i/-e', () {
      expect(lemmatize('libri', language: 'it'), 'libro');
    });

    test('de : pluriels -e/-en/-er', () {
      expect(lemmatize('tagen', language: 'de'), 'tag');
      expect(lemmatize('kinder', language: 'de'), 'kind');
    });

    test('langues non couvertes : identité sans crash', () {
      for (final lang in ['pt', 'nl', 'sv', 'pl', 'ro']) {
        expect(lemmatize('mot', language: lang), 'mot');
      }
    });
  });

  group('inflected candidates inherit the lemma Zipf level (Issue 31 x 32)', () {
    setUpAll(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await WordFrequencyService.preloadLanguage('en');
    });

    test('« dogs » is A1 through « dog »', () {
      final service = const WordFrequencyService();
      expect(service.determineLevel('dogs'), CefrLevel.a1);
      expect(service.getFrequencyScore('dogs'), closeTo(5.1, 0.001),
          reason: 'hérite du Zipf du lemme (dog = 5.1)');
    });

    test('surface form stays authoritative when more frequent than the lemma', () {
      final service = const WordFrequencyService();
      // 'better' (5.76) >= 'good' (6.12) ? non : max -> good ; 'went' -> go.
      expect(service.getFrequencyScore('went'), closeTo(6.03, 0.001),
          reason: 'went (5.5) hérite du Zipf de go (6.03)');
    });
  });

  group('extraction and wordExists resolve the lemma', () {
    late AppDatabase testDb;

    setUp(() async {
      TestWidgetsFlutterBinding.ensureInitialized();
      await WordFrequencyService.preloadLanguage('en');
      testDb = AppDatabase(NativeDatabase.memory());
      await testDb.seedInitialData();
    });

    tearDown(() async {
      await testDb.close();
    });

    test('extractCandidateTokens deduplicates inflected forms of one lemma',
        () {
      final service = TatoebaService();
      final tokens =
          service.extractCandidateTokens('the dogs and the dog play outside');
      expect(tokens, contains('dogs'));
      expect(tokens, isNot(contains('dog')),
          reason: '« dog » est un doublon lemma de « dogs » (première surface gagnée)');
      expect(tokens, contains('play'));
      expect(tokens, contains('outside'));
    });

    test('wordExists matches an inflected form through its lemma', () async {
      await testDb.into(testDb.wordsTable).insert(
            WordsTableCompanion.insert(
              term: 'dog',
              translation: 'chien',
              contextSentence: 'the dog is here',
              category: 'Daily Life & Home',
              level: 'A1',
            ),
          );

      expect(await testDb.wordExists('dog'), isTrue);
      expect(await testDb.wordExists('dogs'), isTrue,
          reason: 'forme fléchie résolue par le lemme');
      expect(await testDb.wordExists('dog', language: 'fr'), isFalse,
          reason: 'la langue reste discriminante');
      expect(await testDb.wordExists('children'), isFalse);
    });
  });
}
