import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/domain/word_frequency_service.dart';

void main() {
  late WordFrequencyService frequencyService;

  setUp(() {
    frequencyService = const WordFrequencyService();
  });

  group('WordFrequencyService Unit Tests', () {
    test('A1 core words return Zipf >= 5.5 and CefrLevel.a1', () {
      expect(frequencyService.determineLevel('water'), equals(CefrLevel.a1));
      expect(frequencyService.determineLevel('eat'), equals(CefrLevel.a1));
      expect(frequencyService.determineLevel('house'), equals(CefrLevel.a1));
      expect(frequencyService.determineLevel('book'), equals(CefrLevel.a1));
      expect(frequencyService.determineLevel('speak'), equals(CefrLevel.a1));
      expect(frequencyService.getFrequencyScore('water'), greaterThanOrEqualTo(5.5));
    });

    test('A2 words return 4.5 <= Zipf < 5.5 and CefrLevel.a2', () {
      expect(frequencyService.determineLevel('travel'), equals(CefrLevel.a2));
      expect(frequencyService.determineLevel('weather'), equals(CefrLevel.a2));
      expect(frequencyService.determineLevel('kitchen'), equals(CefrLevel.a2));
      expect(frequencyService.determineLevel('restaurant'), equals(CefrLevel.a2));
      expect(frequencyService.determineLevel('station'), equals(CefrLevel.a2));
    });

    test('B1 words return 3.5 <= Zipf < 4.5 and CefrLevel.b1', () {
      expect(frequencyService.determineLevel('deadline'), equals(CefrLevel.b1));
      expect(frequencyService.determineLevel('feedback'), equals(CefrLevel.b1));
      expect(frequencyService.determineLevel('benefit'), equals(CefrLevel.b1));
      expect(frequencyService.determineLevel('challenge'), equals(CefrLevel.b1));
    });

    test('B2 words return Zipf < 3.5 and CefrLevel.b2', () {
      expect(frequencyService.determineLevel('troubleshoot'), equals(CefrLevel.b2));
      expect(frequencyService.determineLevel('streamline'), equals(CefrLevel.b2));
      expect(frequencyService.determineLevel('resilience'), equals(CefrLevel.b2));
      expect(frequencyService.determineLevel('milestone'), equals(CefrLevel.b2));
    });

    test('Heuristic fallback works gracefully on unlisted words', () {
      // Short word
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
}
