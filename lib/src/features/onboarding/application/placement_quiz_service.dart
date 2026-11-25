import '../../settings/domain/cefr_level.dart';
import '../../vocabulary/data/initial_words_seed.dart';

/// Mot proposé dans le test de positionnement, extrait du corpus existant.
class PlacementQuizWord {
  final String term;
  final String translation;
  final CefrLevel level;

  const PlacementQuizWord({
    required this.term,
    required this.translation,
    required this.level,
  });
}

/// Test de positionnement : ~10 mots extraits par niveau depuis le corpus
/// existant (du plus courant au plus rare). Le niveau recommandé est le
/// dernier niveau dont l'utilisateur reconnaît encore la majorité des mots
/// (≥ 60 %).
class PlacementQuizService {
  static const int wordsPerLevel = 10;
  static const double requiredRecognitionRate = 0.6;

  static List<PlacementQuizWord> wordsFor(CefrLevel level) {
    final words = initialWordsSeed
        .where((w) => w.level.toUpperCase() == level.code.toUpperCase())
        .toList()
      ..sort((a, b) => b.frequencyScore.compareTo(a.frequencyScore));
    return [
      for (final w in words.take(wordsPerLevel))
        PlacementQuizWord(
          term: w.term,
          translation: w.translation,
          level: level,
        ),
    ];
  }

  /// Blocs de mots présentés successivement, du niveau le plus bas au plus
  /// haut. Les niveaux sans mots dans le corpus sont ignorés.
  static List<List<PlacementQuizWord>> blocks() => [
        for (final level in CefrLevel.values)
          ...[wordsFor(level)].where((block) => block.isNotEmpty),
      ];

  /// Niveau recommandé = dernier niveau présenté dont au moins
  /// [requiredRecognitionRate] des mots est reconnu ; A1 si aucun.
  static CefrLevel recommendLevel(Map<CefrLevel, int> knownByLevel) {
    var recommended = CefrLevel.a1;
    for (final level in CefrLevel.values) {
      if (!knownByLevel.containsKey(level)) break;
      final total = wordsFor(level).length;
      if (total == 0) break;
      if (knownByLevel[level]! / total < requiredRecognitionRate) break;
      recommended = level;
    }
    return recommended;
  }
}
