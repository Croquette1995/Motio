import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/word.dart';
import '../../../core/database/database_providers.dart';
import '../../learning_engine/domain/word_progress.dart';

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

class SelectedStatusFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void select(String? status) => state = status;
}

final selectedStatusFilterProvider =
    NotifierProvider<SelectedStatusFilterNotifier, String?>(SelectedStatusFilterNotifier.new);

final wordProgressMapProvider = FutureProvider<Map<int, String>>((ref) async {
  final repo = ref.watch(progressRepositoryProvider);
  final wordsAsync = await ref.watch(allWordsProvider.future);
  final now = DateTime.now();
  final Map<int, String> map = {};
  for (final word in wordsAsync) {
    final prog = await repo.getProgressByWordId(word.id);
    if (prog == null || prog.lastReviewedAt == null) {
      map[word.id] = 'Nouveau';
    } else if (prog.isDue(now)) {
      map[word.id] = 'À réviser';
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
  final selectedStatus = ref.watch(selectedStatusFilterProvider);
  final progressMap = ref.watch(wordProgressMapProvider).valueOrNull;
  final query = ref.watch(vocabularySearchQueryProvider).trim().toLowerCase();

  return wordsAsync.whenData((words) {
    return words.where((w) {
      final matchesCategory = selectedCat == null || w.category == selectedCat;
      final matchesStatus = selectedStatus == null ||
          (progressMap != null && progressMap[w.id] == selectedStatus);
      final matchesQuery = query.isEmpty ||
          w.term.toLowerCase().contains(query) ||
          w.translation.toLowerCase().contains(query);
      return matchesCategory && matchesStatus && matchesQuery;
    }).toList();
  });
});
