import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../settings/domain/cefr_level.dart';
import '../domain/tatoeba_sentence.dart';
import 'tatoeba_explorer_controller.dart';

class TatoebaExplorerScreen extends ConsumerStatefulWidget {
  const TatoebaExplorerScreen({super.key});

  @override
  ConsumerState<TatoebaExplorerScreen> createState() => _TatoebaExplorerScreenState();
}

class _TatoebaExplorerScreenState extends ConsumerState<TatoebaExplorerScreen> {
  final TextEditingController _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(tatoebaExplorerProvider.notifier).fetchSentences(random: true);
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final state = ref.watch(tatoebaExplorerProvider);
    final notifier = ref.read(tatoebaExplorerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: b.pastelMint,
                shape: BoxShape.circle,
                border: Border.all(color: b.slate, width: 1),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'EXPLORATEUR TATOEBA',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5, fontSize: 16),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.casino),
            tooltip: 'Tirer une phrase au hasard',
            onPressed: state.isLoading
                ? null
                : () {
                    _searchCtrl.clear();
                    notifier.fetchSentences(random: true);
                  },
          ),
        ],
      ),
      body: Column(
        children: [
          // Recherche ou Tirage aléatoire
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: InputDecoration(
                      hintText: 'Chercher une phrase (ex: water, train, eat)...',
                      prefixIcon: Icon(Icons.search, color: b.slate),
                      suffixIcon: _searchCtrl.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18),
                              onPressed: () {
                                _searchCtrl.clear();
                                setState(() {});
                              },
                            )
                          : null,
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        notifier.fetchSentences(query: val, random: false);
                      }
                    },
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: b.slate,
                    foregroundColor: b.cardSurface,
                    shape: bauhausBorder(radius: 8, color: b.slate),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  ),
                  icon: const Icon(Icons.search, size: 18),
                  label: const Text('CHERCHER', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  onPressed: state.isLoading
                      ? null
                      : () {
                          if (_searchCtrl.text.trim().isNotEmpty) {
                            notifier.fetchSentences(query: _searchCtrl.text, random: false);
                          } else {
                            notifier.fetchSentences(random: true);
                          }
                        },
                ),
              ],
            ),
          ),

          // Liste des phrases trouvées (onglets horizontaux)
          if (state.sentences.isNotEmpty)
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Row(
                children: [
                  for (int i = 0; i < state.sentences.length; i++) ...[
                    ChoiceChip(
                      label: Text('PHRASE 0${i + 1}'),
                      selected: state.selectedSentence?.id == state.sentences[i].id,
                      selectedColor: b.pastelYellow,
                      onSelected: (_) {
                        notifier.selectSentence(state.sentences[i]);
                      },
                    ),
                    const SizedBox(width: 8),
                  ],
                ],
              ),
            ),

          const SizedBox(height: 6),

          // Contenu principal
          Expanded(
            child: state.isLoading
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(color: b.slate),
                        const SizedBox(height: 12),
                        Text(
                          'Chargement des phrases Tatoeba...',
                          style: t.bodySmall?.copyWith(color: b.slate.withValues(alpha: 0.7)),
                        ),
                      ],
                    ),
                  )
                : state.errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.wifi_off, size: 48, color: b.pastelRed),
                              const SizedBox(height: 12),
                              Text(state.errorMessage!, textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => notifier.fetchSentences(random: true),
                                child: const Text('Réessayer'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : state.selectedSentence == null
                        ? const Center(child: Text('Aucune phrase sélectionnée.'))
                        : ListView(
                            padding: const EdgeInsets.all(16.0),
                            children: [
                              // Phrase Card
                              Container(
                                padding: const EdgeInsets.all(18),
                                decoration: BoxDecoration(
                                  color: b.cardSurface,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: b.slate, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: b.slate,
                                      offset: const Offset(3, 3),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: b.pastelBlue,
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: b.slate, width: 1),
                                          ),
                                          child: Text(
                                            'TATOEBA #${state.selectedSentence!.id}',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          state.selectedSentence!.license,
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: b.slate.withValues(alpha: 0.6),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      state.selectedSentence!.textEn,
                                      style: t.titleMedium?.copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: b.slate,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: b.chalk,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: b.lineGrey, width: 1),
                                      ),
                                      child: Text(
                                        state.selectedSentence!.textFr,
                                        style: t.bodyMedium?.copyWith(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w600,
                                          color: b.slate.withValues(alpha: 0.8),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 20),

                              // Titre section mots extraits
                              Row(
                                children: [
                                  Text(
                                    'MOTS DE LA PHRASE',
                                    style: t.labelSmall?.copyWith(
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1.2,
                                      color: b.slate.withValues(alpha: 0.7),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    '${state.candidates.length} mot(s)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: b.slate.withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              if (state.candidates.isEmpty)
                                const Center(
                                  child: Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text('Aucun mot de vocabulaire extrait de cette phrase.'),
                                  ),
                                ),

                              for (final candidate in state.candidates)
                                _buildCandidateCard(context, candidate, state.selectedSentence!),
                            ],
                          ),
          ),
        ],
      ),
    );
  }

  Widget _buildCandidateCard(
    BuildContext context,
    ExtractedCandidateWord candidate,
    TatoebaSentence sentence,
  ) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final notifier = ref.read(tatoebaExplorerProvider.notifier);

    final levelBg = switch (candidate.estimatedLevel) {
      CefrLevel.a1 => b.pastelMint,
      CefrLevel.a2 => b.pastelBlue,
      CefrLevel.b1 => b.pastelYellow,
      CefrLevel.b2 => b.pastelRed,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: b.cardSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: b.slate, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: b.slate,
            offset: const Offset(2, 2),
            blurRadius: 0,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Term + badges
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      candidate.term,
                      style: t.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                        color: b.slate,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: levelBg,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: b.slate, width: 1),
                      ),
                      child: Text(
                        candidate.estimatedLevel.code,
                        style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (candidate.pos != null)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: b.chalk,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: b.lineGrey, width: 1),
                        ),
                        child: Text(
                          candidate.pos!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: b.slate.withValues(alpha: 0.7),
                          ),
                        ),
                      ),
                    if (candidate.suggestedCategory != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: b.pastelYellow,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: b.slate, width: 1),
                        ),
                        child: Text(
                          candidate.suggestedCategory!.toUpperCase(),
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: b.slate,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      'Fréquence : ${candidate.frequencyScore.toStringAsFixed(1)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: b.slate.withValues(alpha: 0.6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 10),
                    if (candidate.isAlreadyInDb)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: b.pastelMint.withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: b.pastelMint, width: 1),
                        ),
                        child: Text(
                          'DÉJÀ AJOUTÉ',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: b.slate,
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                        decoration: BoxDecoration(
                          color: b.pastelYellow.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: b.slate, width: 0.8),
                        ),
                        child: const Text(
                          'NOUVEAU',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                  ],
                ),
                if (candidate.translation != null && candidate.translation!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Traduction : ${candidate.translation}',
                    style: TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w600,
                      color: b.slate.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Bouton d'action
          if (candidate.isAlreadyInDb)
            Icon(Icons.check_circle, color: b.pastelMint, size: 28)
          else
            FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: b.slate,
                foregroundColor: b.cardSurface,
                shape: bauhausBorder(radius: 6, color: b.slate),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              ),
              icon: const Icon(Icons.add, size: 16),
              label: const Text(
                'AJOUTER',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
              ),
              onPressed: () async {
                await notifier.addCandidateWordToDeck(
                  candidate: candidate,
                  sentence: sentence,
                );
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('« ${candidate.term} » ajouté avec succès à votre catalogue !'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
        ],
      ),
    );
  }
}
