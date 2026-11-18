import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/bauhaus_theme.dart';
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
    final b = context.bauhaus;

    return Container(
      margin: const EdgeInsets.only(top: 10.0),
      decoration: BoxDecoration(
        color: b.chalk,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: b.slate,
          width: 1.0,
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          key: PageStorageKey('wiktionary_${widget.term}'),
          shape: const Border(),
          collapsedShape: const Border(),
          backgroundColor: Colors.transparent,
          collapsedBackgroundColor: Colors.transparent,
          title: Row(
            children: [
              Icon(
                Icons.auto_awesome,
                size: 16,
                color: b.slate,
              ),
              const SizedBox(width: 8),
              Text(
                'Définitions et détails',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: b.slate,
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
    final b = context.bauhaus;

    return detailsAsync.when(
      data: (details) {
        if (details.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Aucune donnée complémentaire disponible sur Wiktionnaire.',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: b.slate.withValues(alpha: 0.6),
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
            // French Cognitive Bridge / Pont Linguistique
            if (details.frenchBridge != null && details.frenchBridge!.isNotEmpty) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12.0),
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: b.pastelBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: b.slate, width: 1.2),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.hub, size: 16, color: b.slate),
                        const SizedBox(width: 6),
                        Text(
                          'LIEN AVEC LE FRANÇAIS',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.6,
                            color: b.slate,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      details.frenchBridge!,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.35,
                        fontWeight: FontWeight.w600,
                        color: b.slate,
                      ),
                    ),
                  ],
                ),
              ),
            ],

            // Definitions group
            if (groupedDefs.isNotEmpty) ...[
              const SizedBox(height: 4),
              const Text(
                'Définitions :',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: b.pastelYellow,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: b.slate, width: 0.8),
                        ),
                        child: Text(
                          pos,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                            color: b.slate,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      ...defs.map((d) => Padding(
                            padding: const EdgeInsets.only(left: 6.0, bottom: 4.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        d.text,
                                        style: const TextStyle(fontSize: 13, height: 1.2),
                                      ),
                                      if (d.example != null && d.example!.isNotEmpty)
                                        Text(
                                          'Ex. "${d.example}"',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontStyle: FontStyle.italic,
                                            color: b.slate.withValues(alpha: 0.7),
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
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 4,
                children: details.synonyms
                    .map((syn) => Chip(
                          label: Text(syn, style: const TextStyle(fontSize: 11)),
                          padding: EdgeInsets.zero,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          backgroundColor: b.cardSurface,
                          side: BorderSide(color: b.slate, width: 1.0),
                        ))
                    .toList(),
              ),
            ],

            // Translations
            if (details.translations.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Traductions :',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
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
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          visualDensity: VisualDensity.compact,
                          backgroundColor: b.pastelBlue.withValues(alpha: 0.25),
                          side: BorderSide(color: b.slate, width: 1.0),
                        ))
                    .toList(),
              ),
            ],

            // Etymology
            if (details.etymology != null && details.etymology!.trim().isNotEmpty) ...[
              const SizedBox(height: 8),
              Divider(height: 12, thickness: 1, color: b.lineGrey),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.history_edu, size: 14, color: b.slate),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Étymologie : ${details.etymology}',
                      style: TextStyle(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: b.slate.withValues(alpha: 0.75),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        );
      },
      loading: () => Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 14,
                height: 14,
                child: CircularProgressIndicator(strokeWidth: 2, color: b.slate),
              ),
              const SizedBox(width: 10),
              Text(
                'Chargement depuis Wiktionnaire...',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic, color: b.slate),
              ),
            ],
          ),
        ),
      ),
      error: (_, __) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          'Erreur lors du chargement des données complémentaires.',
          style: TextStyle(
            fontSize: 12,
            fontStyle: FontStyle.italic,
            color: b.pastelRed,
          ),
        ),
      ),
    );
  }
}
