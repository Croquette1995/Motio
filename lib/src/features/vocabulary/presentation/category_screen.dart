import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bauhaus_theme.dart';
import 'vocabulary_controller.dart';
import 'wiktionary_enrichment_widget.dart';

class CategoryScreen extends ConsumerWidget {
  const CategoryScreen({super.key});

  Widget _buildStatusBadge(BuildContext context, String status) {
    final b = context.bauhaus;
    final (Color bg, Color fg) = switch (status) {
      'À réviser' => (b.pastelRed, b.slate),
      'Maîtrisé' => (b.pastelMint, b.slate),
      'En révision' => (b.pastelYellow, b.slate),
      'En apprentissage' => (b.pastelBlue, b.slate),
      _ => (b.chalk, b.slate),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: b.slate, width: 1),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontWeight: FontWeight.w800,
          color: fg,
          fontSize: 10,
          letterSpacing: 0.6,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final filteredWordsAsync = ref.watch(filteredWordsProvider);
    final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final selectedLevel = ref.watch(selectedLevelFilterProvider);
    final selectedStatus = ref.watch(selectedStatusFilterProvider);
    final progressMapAsync = ref.watch(wordProgressMapProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: b.pastelBlue,
                shape: BoxShape.circle,
                border: Border.all(color: b.slate, width: 1),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'CATALOGUE DE VOCABULAIRE',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.travel_explore),
            tooltip: 'Explorer Tatoeba (Zéro Clé API)',
            onPressed: () => context.push('/tatoeba'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search TextField
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Rechercher un mot ou une traduction...',
                prefixIcon: Icon(Icons.search, color: b.slate),
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
                        label: const Text('TOUTES'),
                        selected: selectedCategory == null,
                        selectedColor: b.pastelYellow,
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
                            label: Text(cat.toUpperCase()),
                            selected: isSelected,
                            selectedColor: b.pastelYellow,
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

              // Level Filter Chips (A1, A2, B1, B2)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('TOUS NIVEAUX'),
                      selected: selectedLevel == null,
                      selectedColor: b.pastelMint,
                      onSelected: (_) {
                        ref.read(selectedLevelFilterProvider.notifier).select(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    ...['A1', 'A2', 'B1', 'B2'].map((lvl) {
                      final isSelected = selectedLevel?.toUpperCase() == lvl;
                      final chipColor = switch (lvl) {
                        'A1' => b.pastelMint,
                        'A2' => b.pastelBlue,
                        'B1' => b.pastelYellow,
                        _ => b.pastelRed,
                      };

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text('NIVEAU $lvl'),
                          selected: isSelected,
                          selectedColor: chipColor,
                          onSelected: (selected) {
                            ref.read(selectedLevelFilterProvider.notifier).select(
                                  selected ? lvl : null,
                                );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 4),

              // Status Filter Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('TOUS STATUTS'),
                      selected: selectedStatus == null,
                      selectedColor: b.pastelBlue,
                      onSelected: (_) {
                        ref.read(selectedStatusFilterProvider.notifier).select(null);
                      },
                    ),
                    const SizedBox(width: 8),
                    ...['À réviser', 'En apprentissage', 'En révision', 'Maîtrisé', 'Nouveau'].map((st) {
                      final isSelected = selectedStatus == st;
                      final chipAccent = switch (st) {
                        'À réviser' => b.pastelRed,
                        'Maîtrisé' => b.pastelMint,
                        'En révision' => b.pastelYellow,
                        _ => b.pastelBlue,
                      };

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          avatar: st == 'À réviser'
                              ? Icon(Icons.alarm, size: 14, color: b.slate)
                              : null,
                          label: Text(st.toUpperCase()),
                          selected: isSelected,
                          selectedColor: chipAccent,
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
                      return Center(
                        child: Text(
                          'Aucun mot ne correspond à votre recherche.',
                          style: t.bodyMedium?.copyWith(color: b.slate.withValues(alpha: 0.6)),
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: words.length,
                      itemBuilder: (context, index) {
                        final word = words[index];

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12.0),
                          decoration: BoxDecoration(
                            color: b.cardSurface,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: b.slate, width: 1.5),
                            boxShadow: [
                              BoxShadow(
                                color: b.slate,
                                offset: const Offset(2, 2),
                                blurRadius: 0,
                              ),
                            ],
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
                                      style: t.titleMedium?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: b.slate,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (progressMapAsync.hasValue) ...[
                                          _buildStatusBadge(
                                            context,
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
                                              color: b.cardSurface,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: b.slate, width: 1),
                                            ),
                                            child: Text(
                                              word.level.toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w800,
                                                color: b.slate,
                                                fontSize: 10,
                                                letterSpacing: 0.5,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 6,
                                              vertical: 3,
                                            ),
                                            decoration: BoxDecoration(
                                              color: b.chalk,
                                              borderRadius: BorderRadius.circular(6),
                                              border: Border.all(color: b.lineGrey, width: 1),
                                            ),
                                            child: Text(
                                              word.pos.toUpperCase(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                color: b.slate.withValues(alpha: 0.7),
                                                fontSize: 9,
                                                letterSpacing: 0.5,
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
                                  style: t.bodyMedium?.copyWith(
                                    fontStyle: FontStyle.italic,
                                    fontWeight: FontWeight.w600,
                                    color: b.slate.withValues(alpha: 0.8),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: b.chalk,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: b.lineGrey, width: 1.2),
                                  ),
                                  child: Text(
                                    word.contextSentence,
                                    style: t.bodyMedium?.copyWith(height: 1.3),
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
                  loading: () => Center(
                    child: CircularProgressIndicator(color: b.slate),
                  ),
                  error: (err, __) => Center(child: Text('Erreur: $err')),
                ),
              ),
            ],
          ),
        );
  }
}
