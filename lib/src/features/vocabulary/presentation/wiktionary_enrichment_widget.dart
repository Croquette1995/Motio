import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/wiktionary_provider.dart';
import '../domain/word_details.dart';

class WiktionaryEnrichmentWidget extends ConsumerStatefulWidget {
  final String term;

  const WiktionaryEnrichmentWidget({
    super.key,
    required this.term,
  });

  @override
  ConsumerState<WiktionaryEnrichmentWidget> createState() =>
      _WiktionaryEnrichmentWidgetState();
}

class _WiktionaryEnrichmentWidgetState
    extends ConsumerState<WiktionaryEnrichmentWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
          width: 0.8,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey('wiktionary_${widget.term}'),
          title: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 18,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              Text(
                'Enrichissement linguistique',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
          tilePadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          children: [
            if (_isExpanded) _buildDetailsContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsContent(BuildContext context) {
    final detailsAsync = ref.watch(wordDetailsProvider(widget.term));

    return detailsAsync.when(
      data: (details) {
        if (details.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Aucune donnée complémentaire disponible sur Wiktionnaire.',
              style: TextStyle(
                fontSize: 13,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
            ),
          );
        }

        // Group definitions by part of speech
        final Map<String, List<WordDefinition>> groupedDefs = {};
        for (final def in details.definitions) {
          groupedDefs.putIfAbsent(def.partOfSpeech, () => []).add(def);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Definitions group
            if (groupedDefs.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Text(
                'Définitions :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              ...groupedDefs.entries.map((entry) {
                final pos = entry.key;
                final defs = entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pos,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      ...defs.map((d) => Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d.text,
                                        style: const TextStyle(
                                            fontSize: 13, height: 1.2),
                                      ),
                                      if (d.example != null &&
                                          d.example!.isNotEmpty)
                                        Text(
                                          'Ex. "${d.example}"',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: Colors.grey.shade700,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ],
                  ),
                );
              }),
            ],

            // Synonyms
            if (details.synonyms.isNotEmpty) ...[
              const SizedBox(height: 6),
              const Text(
                'Synonymes :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: details.synonyms
                    .map((syn) => Chip(
                          label: Text(syn, style: const TextStyle(fontSize: 11)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .surfaceContainerHigh,
                        ))
                    .toList(),
              ),
            ],

            // Translations
            if (details.translations.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Traductions :',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: details.translations
                    .map((tr) => Chip(
                          label: Text(
                            '${tr.language}: ${tr.term}',
                            style: const TextStyle(fontSize: 11),
                          ),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          backgroundColor: Colors.blue.shade50,
                          side: BorderSide(color: Colors.blue.shade200),
                        ))
                    .toList(),
              ),
            ],

            // Etymology
            if (details.etymology != null &&
                details.etymology!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              const Divider(height: 12, thickness: 0.5),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.history_edu, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'Étymologie : ${details.etymology}',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              SizedBox(width: 10),
              Text(
                'Chargement depuis Wiktionnaire...',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
      error: (_, __) => const Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Erreur lors du chargement des données complémentaires.',
          style: TextStyle(
            fontSize: 13,
            fontStyle: FontStyle.italic,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
