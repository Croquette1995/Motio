import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'vocabulary_controller.dart';
import 'wiktionary_enrichment_widget.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  Widget _buildStatusBadge(String status) {
    final (Color bg, Color fg) = switch (status) {
      'À réviser' => (Colors.red.shade100, Colors.red.shade900),
      'Maîtrisé' => (Colors.green.shade100, Colors.green.shade800),
      'En révision' => (Colors.purple.shade100, Colors.purple.shade800),
      'En apprentissage' => (Colors.orange.shade100, Colors.orange.shade800),
      _ => (Colors.grey.shade200, Colors.grey.shade800),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: fg,
          fontSize: 12,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredWordsAsync = ref.watch(filteredWordsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedStatus = ref.watch(selectedStatusFilterProvider);
    final progressMapAsync = ref.watch(wordProgressMapProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue de Vocabulaire'),
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un mot ou une traduction...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
              ),
              onChanged: (val) {
                ref.read(vocabularySearchQueryProvider.notifier).update(val);
              },
            ),
          ),

          // Category Chips
          categoriesAsync.when(
            data: (categories) => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('Toutes'),
                    selected: selectedCategory == null,
                    onSelected: (_) {
                      ref.read(selectedCategoryProvider.notifier).select(null);
                    },
                  ),
                  const SizedBox(width: 8),
                  ...categories.map((cat) {
                    final isSelected = selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ChoiceChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (selected) {
                          ref.read(selectedCategoryProvider.notifier).select(
                                selected ? cat : null,
                              );
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 6),

          // Status Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Row(
              children: [
                FilterChip(
                  label: const Text('Tous statuts'),
                  selected: selectedStatus == null,
                  onSelected: (_) {
                    ref.read(selectedStatusFilterProvider.notifier).select(null);
                  },
                ),
                const SizedBox(width: 8),
                ...['À réviser', 'En apprentissage', 'En révision', 'Maîtrisé', 'Nouveau'].map((st) {
                  final isSelected = selectedStatus == st;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: FilterChip(
                      avatar: st == 'À réviser'
                          ? const Icon(Icons.alarm, size: 16, color: Colors.redAccent)
                          : null,
                      label: Text(st),
                      selected: isSelected,
                      onSelected: (selected) {
                        ref.read(selectedStatusFilterProvider.notifier).select(
                              selected ? st : null,
                            );
                      },
                    ),
                  );
                }),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Words list
          Expanded(
            child: filteredWordsAsync.when(
              data: (words) {
                if (words.isEmpty) {
                  return const Center(
                    child: Text('Aucun mot ne correspond à votre recherche.'),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  word.term,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (progressMapAsync.hasValue) ...[
                                      _buildStatusBadge(
                                        progressMapAsync.value![word.id] ?? 'Nouveau',
                                      ),
                                      const SizedBox(width: 8),
                                    ],
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blueAccent.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        word.level,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueAccent,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              word.translation,
                              style: TextStyle(
                                fontSize: 15,
                                fontStyle: FontStyle.italic,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                word.contextSentence,
                                style: const TextStyle(fontSize: 14, height: 1.3),
                              ),
                            ),
                            WiktionaryEnrichmentWidget(term: word.term),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, __) => Center(child: Text('Erreur: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
