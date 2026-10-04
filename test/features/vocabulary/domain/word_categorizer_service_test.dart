import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/vocabulary/domain/word_categorizer_service.dart';

void main() {
  group('WordCategorizerService Unit Tests', () {
    const categorizer = WordCategorizerService();

    test('categorizes basic food terms into Food & Drink', () {
      expect(categorizer.categorizeWord('bread'), equals('Food & Drink'));
      expect(categorizer.categorizeWord('water'), equals('Food & Drink'));
      expect(categorizer.categorizeWord('apple'), equals('Food & Drink'));
      expect(categorizer.categorizeWord('coffee'), equals('Food & Drink'));
      expect(categorizer.categorizeWord('restaurant'), equals('Food & Drink'));
    });

    test('categorizes travel terms into Travel & Places', () {
      expect(categorizer.categorizeWord('airport'), equals('Travel & Places'));
      expect(categorizer.categorizeWord('station'), equals('Travel & Places'));
      expect(categorizer.categorizeWord('travel'), equals('Travel & Places'));
      expect(categorizer.categorizeWord('ticket'), equals('Travel & Places'));
      expect(categorizer.categorizeWord('hotel'), equals('Travel & Places'));
    });

    test('categorizes greeting and presentation terms into Basics & Greetings', () {
      expect(categorizer.categorizeWord('hello'), equals('Basics & Greetings'));
      expect(categorizer.categorizeWord('welcome'), equals('Basics & Greetings'));
      expect(categorizer.categorizeWord('name'), equals('Basics & Greetings'));
      expect(categorizer.categorizeWord('friend'), equals('Basics & Greetings'));
    });

    test('categorizes tech and work terms into Work & Tech', () {
      expect(categorizer.categorizeWord('computer'), equals('Work & Tech'));
      expect(categorizer.categorizeWord('deadline'), equals('Work & Tech'));
      expect(categorizer.categorizeWord('meeting'), equals('Work & Tech'));
      expect(categorizer.categorizeWord('software'), equals('Work & Tech'));
    });

    test('uses context sentence when term alone is ambiguous or unknown', () {
      final cat = categorizer.categorizeWord(
        'fresh',
        contextSentence: 'We buy fresh bread and hot coffee every morning at the bakery.',
      );
      expect(cat, equals('Food & Drink'));

      final catTravel = categorizer.categorizeWord(
        'fast',
        contextSentence: 'The train to the airport was very fast and comfortable.',
      );
      expect(catTravel, equals('Travel & Places'));
    });

    test('normalizes legacy category names correctly', () {
      expect(WordCategorizerService.getDomainById('Daily Life').id, equals('Daily Life & Home'));
      expect(WordCategorizerService.getDomainById('Daily Life & Travel').id, equals('Travel & Places'));
      expect(WordCategorizerService.getDomainById('Social & Abstract').id, equals('Social & Mind'));
      expect(WordCategorizerService.getDomainById('Food & Drink').id, equals('Food & Drink'));
    });
  });
}
