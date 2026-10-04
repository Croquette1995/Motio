import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/database_providers.dart';
import '../../learning_engine/domain/word_progress.dart';
import '../../settings/domain/cefr_level.dart';
import '../domain/word.dart';
import '../domain/word_categorizer_service.dart';
import '../presentation/vocabulary_controller.dart';

/// Données de progression et d'évolution d'une catégorie dans un niveau donné
class CategoryProgressData {
  final String categoryName;
  final SemanticDomain domain;
  final List<Word> words;
  final int totalCount;
  final int masteredCount;
  final int reviewCount;
  final int learningCount;
  final int newCount;

  const CategoryProgressData({
    required this.categoryName,
    required this.domain,
    required this.words,
    required this.totalCount,
    required this.masteredCount,
    required this.reviewCount,
    required this.learningCount,
    required this.newCount,
  });

  /// Pourcentage de mots maîtrisés dans cette catégorie (0.0 à 1.0)
  double get masteryRate => totalCount == 0 ? 0.0 : (masteredCount / totalCount);

  /// Pourcentage de mots ayant été explorés au moins une fois (0.0 à 1.0)
  double get explorationRate =>
      totalCount == 0 ? 0.0 : ((totalCount - newCount) / totalCount);

  /// Statut textuel d'évolution de la catégorie
  String get statusLabel {
    if (totalCount == 0) return 'Vide';
    if (masteredCount == totalCount) return 'Maîtrisée';
    if (explorationRate > 0) return 'En cours d\'exploration';
    return 'Non commencée';
  }
}

/// Synthèse globale d'un niveau CECRL (A1, A2, etc.)
class LevelProgressData {
  final CefrLevel level;
  final int totalWords;
  final int targetWords;
  final List<CategoryProgressData> categories;
  final int totalMastered;
  final int totalReview;
  final int totalLearning;
  final int totalNew;

  const LevelProgressData({
    required this.level,
    required this.totalWords,
    required this.targetWords,
    required this.categories,
    required this.totalMastered,
    required this.totalReview,
    required this.totalLearning,
    required this.totalNew,
  });

  double get levelCompletionRate =>
      targetWords == 0 ? 0.0 : (totalWords / targetWords).clamp(0.0, 1.0);

  double get masteryRate =>
      totalWords == 0 ? 0.0 : (totalMastered / totalWords).clamp(0.0, 1.0);
}

/// Provider fournissant les données de progression par catégorie pour un niveau donné
final levelCategoryProgressProvider =
    FutureProvider.family<LevelProgressData, CefrLevel>((ref, level) async {
  final allWords = await ref.watch(allWordsProvider.future);
  final progressRepo = ref.watch(progressRepositoryProvider);

  // Filtrer les mots appartenant au niveau demandé
  final levelWords = allWords
      .where((w) => w.level.toUpperCase() == level.code.toUpperCase())
      .toList();

  // Récupérer les états de progression pour chaque mot
  final Map<int, WordProgress?> progressMap = {};
  for (final word in levelWords) {
    progressMap[word.id] = await progressRepo.getProgressByWordId(word.id);
  }

  // Grouper les mots par domaine / catégorie
  final Map<String, List<Word>> wordsByCategory = {};
  for (final word in levelWords) {
    wordsByCategory.putIfAbsent(word.category, () => []).add(word);
  }

  // Construire la liste des données de progression par catégorie
  final List<CategoryProgressData> categoryProgressList = [];
  int levelMastered = 0;
  int levelReview = 0;
  int levelLearning = 0;
  int levelNew = 0;

  for (final entry in wordsByCategory.entries) {
    final catName = entry.key;
    final words = entry.value;
    final domain = WordCategorizerService.getDomainById(catName);

    int catMastered = 0;
    int catReview = 0;
    int catLearning = 0;
    int catNew = 0;

    for (final word in words) {
      final prog = progressMap[word.id];
      if (prog == null || prog.lastReviewedAt == null || prog.status == WordStatus.newWord) {
        catNew++;
      } else if (prog.status == WordStatus.mastered) {
        catMastered++;
      } else if (prog.status == WordStatus.review || prog.isDue()) {
        catReview++;
      } else {
        catLearning++;
      }
    }

    levelMastered += catMastered;
    levelReview += catReview;
    levelLearning += catLearning;
    levelNew += catNew;

    categoryProgressList.add(
      CategoryProgressData(
        categoryName: catName,
        domain: domain,
        words: words,
        totalCount: words.length,
        masteredCount: catMastered,
        reviewCount: catReview,
        learningCount: catLearning,
        newCount: catNew,
      ),
    );
  }

  // Trier les catégories par nombre décroissant de mots puis par nom
  categoryProgressList.sort((a, b) {
    final cmp = b.totalCount.compareTo(a.totalCount);
    if (cmp != 0) return cmp;
    return a.categoryName.compareTo(b.categoryName);
  });

  return LevelProgressData(
    level: level,
    totalWords: levelWords.length,
    targetWords: level.targetWordCount,
    categories: categoryProgressList,
    totalMastered: levelMastered,
    totalReview: levelReview,
    totalLearning: levelLearning,
    totalNew: levelNew,
  );
});
