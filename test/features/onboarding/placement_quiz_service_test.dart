import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/onboarding/application/placement_quiz_service.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/data/initial_words_seed.dart';

void main() {
  group('PlacementQuizService', () {
    test('extrait au plus 10 mots par niveau depuis le corpus, du plus courant au plus rare', () {
      for (final level in CefrLevel.values) {
        final words = PlacementQuizService.wordsFor(level);
        final corpusCount =
            initialWordsSeed.where((s) => s.level == level.code).length;
        expect(
          words.length,
          corpusCount < PlacementQuizService.wordsPerLevel
              ? corpusCount
              : PlacementQuizService.wordsPerLevel,
        );
        for (final word in words) {
          expect(word.level, level);
          expect(
            initialWordsSeed.any(
              (s) => s.term == word.term && s.level == level.code,
            ),
            isTrue,
          );
        }
        final scores = [
          for (final word in words)
            initialWordsSeed
                .firstWhere((s) => s.term == word.term)
                .frequencyScore,
        ];
        final sorted = [...scores]..sort((a, b) => b.compareTo(a));
        expect(scores, sorted);
      }
      expect(PlacementQuizService.wordsFor(CefrLevel.a1).length, 10);
      expect(PlacementQuizService.wordsFor(CefrLevel.a1).first.term, 'hello');
    });

    test('le quiz ne présente que des niveaux présents dans le corpus', () {
      final blocks = PlacementQuizService.blocks();
      expect(blocks, isNotEmpty);
      for (final block in blocks) {
        expect(block, isNotEmpty);
      }
      expect(blocks.first.first.level, CefrLevel.a1);
    });

    test('recommande A1 quand aucun niveau n\'est reconnu à 60 %', () {
      final recommendation = PlacementQuizService.recommendLevel({
        CefrLevel.a1: 5,
        CefrLevel.a2: 0,
      });
      expect(recommendation, CefrLevel.a1);
    });

    test('recommande le dernier niveau reconnu à au moins 60 %', () {
      final recommendation = PlacementQuizService.recommendLevel({
        CefrLevel.a1: 6,
        CefrLevel.a2: 10,
        CefrLevel.b1: 7,
        CefrLevel.b2: 3,
      });
      expect(recommendation, CefrLevel.b1);
    });

    test('60 % exactement compte comme niveau reconnu', () {
      expect(
        PlacementQuizService.recommendLevel({CefrLevel.a1: 6}),
        CefrLevel.a1,
      );
      expect(
        PlacementQuizService.recommendLevel({CefrLevel.a1: 10, CefrLevel.a2: 6}),
        CefrLevel.a2,
      );
    });

    test('recommande B2 quand tous les niveaux sont reconnus', () {
      final recommendation = PlacementQuizService.recommendLevel({
        CefrLevel.a1: 10,
        CefrLevel.a2: 10,
        CefrLevel.b1: 10,
        CefrLevel.b2: 10,
      });
      expect(recommendation, CefrLevel.b2);
    });
  });
}
