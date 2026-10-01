import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/word.dart';
import '../domain/word_progress.dart';
import '../../../core/database/database_providers.dart';

final allWordsProvider = FutureProvider<List<Word>>((ref) async {
  final repo = ref.watch(wordRepositoryProvider);
  return repo.getAllWords();
});

final categoriesProvider = FutureProvider<List<String>>((ref) async {
  final repo = ref.watch(wordRepositoryProvider);
  return repo.getCategories();
});

class SelectedCategoryNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void select(String? cat) => state = cat;
}

final selectedCategoryProvider =
    NotifierProvider<SelectedCategoryNotifier, String?>(SelectedCategoryNotifier.new);

class SearchQueryNotifier extends Notifier<String> {
  @override
  String build() => '';
  void update(String query) => state = query;
}

final vocabularySearchQueryProvider =
    NotifierProvider<SearchQueryNotifier, String>(SearchQueryNotifier.new);

final wordProgressMapProvider = FutureProvider<Map<int, String>>((ref) async {
  final repo = ref.watch(progressRepositoryProvider);
  final wordsAsync = await ref.watch(allWordsProvider.future);
  final Map<int, String> map = {};
  for (final word in wordsAsync) {
    final prog = await repo.getProgressByWordId(word.id);
    if (prog == null || prog.lastReviewedAt == null) {
      map[word.id] = 'Nouveau';
    } else {
      map[word.id] = switch (prog.status) {
        WordStatus.newWord => 'Nouveau',
        WordStatus.learning => 'En apprentissage',
        WordStatus.review => 'En révision',
        WordStatus.mastered => 'Maîtrisé',
      };
    }
  }
  return map;
});

final filteredWordsProvider = Provider<AsyncValue<List<Word>>>((ref) {
  final wordsAsync = ref.watch(allWordsProvider);
  final selectedCat = ref.watch(selectedCategoryProvider);
  final query = ref.watch(vocabularySearchQueryProvider).trim().toLowerCase();

  return wordsAsync.whenData((words) {
    return words.where((w) {
      final matchesCategory = selectedCat == null || w.category == selectedCat;
      final matchesQuery = query.isEmpty ||
          w.term.toLowerCase().contains(query) ||
          w.translation.toLowerCase().contains(query);
      return matchesCategory && matchesQuery;
    }).toList();
  });
});
