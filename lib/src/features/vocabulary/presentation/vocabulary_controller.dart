import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/word.dart';
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
