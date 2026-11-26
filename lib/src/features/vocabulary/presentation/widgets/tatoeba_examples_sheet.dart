import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/bauhaus_theme.dart';
import '../../../settings/application/voice_settings_controller.dart';
import '../../domain/tatoeba_sentence.dart';
import '../../domain/word.dart';
import '../../data/tatoeba_service.dart';

class TatoebaExamplesSheet extends ConsumerStatefulWidget {
  final Word word;

  const TatoebaExamplesSheet({super.key, required this.word});

  static Future<void> show(BuildContext context, Word word) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TatoebaExamplesSheet(word: word),
    );
  }

  @override
  ConsumerState<TatoebaExamplesSheet> createState() => _TatoebaExamplesSheetState();
}

class _TatoebaExamplesSheetState extends ConsumerState<TatoebaExamplesSheet> {
  late Future<List<TatoebaSentence>> _futureExamples;

  @override
  void initState() {
    super.initState();
    final service = ref.read(tatoebaServiceProvider);
    _futureExamples = service.getExamplesForWord(
      word: widget.word.term,
      limit: 8,
    );
  }

  void _reloadRandom() {
    final service = ref.read(tatoebaServiceProvider);
    setState(() {
      _futureExamples = service.getExamplesForWord(
        word: widget.word.term,
        limit: 8,
        random: true,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final voiceNotifier = ref.read(voiceSettingsProvider.notifier);

    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: b.cardSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(color: b.slate, width: 2),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: b.pastelBlue,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: b.slate, width: 1.2),
                  ),
                  child: Icon(Icons.menu_book, color: b.slate, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXEMPLES EN CONTEXTE TATOEBA',
                        style: t.labelSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: b.slate.withValues(alpha: 0.6),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            widget.word.term,
                            style: t.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: b.slate,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '(${widget.word.translation})',
                            style: t.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: b.slate.withValues(alpha: 0.7),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.refresh),
                  tooltip: 'Tirer d\'autres phrases',
                  onPressed: _reloadRandom,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1),

          // Content
          Expanded(
            child: FutureBuilder<List<TatoebaSentence>>(
              future: _futureExamples,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        'Impossible de charger les exemples de phrases.\nVérifiez votre connexion internet.',
                        textAlign: TextAlign.center,
                        style: t.bodyMedium?.copyWith(color: b.pastelRed),
                      ),
                    ),
                  );
                }

                final sentences = snapshot.data ?? [];
                if (sentences.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.search_off, size: 40, color: b.slate.withValues(alpha: 0.4)),
                          const SizedBox(height: 12),
                          Text(
                            'Aucun exemple supplémentaire trouvé sur Tatoeba pour "${widget.word.term}".',
                            textAlign: TextAlign.center,
                            style: t.bodyMedium?.copyWith(color: b.slate.withValues(alpha: 0.7)),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  itemCount: sentences.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final s = sentences[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: b.cardSurface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: b.slate, width: 1.0),
                        boxShadow: [
                          BoxShadow(
                            color: b.slate,
                            offset: const Offset(2, 2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Text(
                                  s.textEn,
                                  style: t.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: b.slate,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.volume_up, size: 20),
                                tooltip: 'Écouter la phrase',
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                                onPressed: () {
                                  voiceNotifier.speak(s.textEn);
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: b.chalk,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: b.lineGrey, width: 1),
                            ),
                            child: Text(
                              s.textFr,
                              style: t.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: b.slate.withValues(alpha: 0.8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'Tatoeba #${s.id} · ${s.license}',
                              style: TextStyle(
                                fontSize: 9,
                                color: b.slate.withValues(alpha: 0.5),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
