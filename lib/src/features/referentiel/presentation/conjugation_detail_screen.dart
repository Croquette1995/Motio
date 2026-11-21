import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../vocabulary/presentation/vocabulary_controller.dart';
import '../application/pronoun_renderer.dart';
import '../domain/conjugation.dart';
import '../domain/grammar_profile.dart';

class ConjugationDetailScreen extends ConsumerWidget {
  final int conjugationId;

  const ConjugationDetailScreen({super.key, required this.conjugationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(referentielRepositoryProvider);
    final bridge = ref.watch(vocabularyBridgeServiceProvider);
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return FutureBuilder<(ConjugationRecord?, LanguageRecord?)>(
      future: () async {
        final conj = await repo.getConjugationById(conjugationId);
        if (conj == null) return (null, null);
        final lang = await repo.getLanguageById(conj.langId);
        return (conj, lang);
      }(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('CONJUGAISON')),
            body: Center(child: CircularProgressIndicator(color: b.slate)),
          );
        }

        final conj = snapshot.data!.$1;
        final lang = snapshot.data!.$2;
        if (conj == null || lang == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('CONJUGAISON')),
            body: const Center(child: Text('Fiche de conjugaison introuvable.')),
          );
        }

        final profile = lang.grammarProfile;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              conj.lemma.toUpperCase(),
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Éditer dans le Studio',
                onPressed: () => context.push('/referentiel/studio/conjugation', extra: conj),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildHeaderCard(context, conj, lang),
              const SizedBox(height: 12),
              FutureBuilder(
                future: bridge.findWordForMorphology(
                  langCode: conj.langCode,
                  lemma: conj.lemma,
                ),
                builder: (context, wordSnap) {
                  final word = wordSnap.data;
                  if (word == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.link, size: 18),
                      label: Text('Voir « ${word.term} » dans le Vocabulaire'),
                      onPressed: () {
                        ref.read(vocabularySearchQueryProvider.notifier).update(word.term);
                        context.go('/vocabulary');
                      },
                    ),
                  );
                },
              ),
              ...profile.paradigms.map((paradigm) {
                final matching = conj.forms
                    .where((f) => f.mood == paradigm.mood && f.tense == paradigm.tense)
                    .toList();
                if (matching.isEmpty && !conj.isDefective) {
                  return const SizedBox.shrink();
                }

                final slots = paradigm.expectedSlots(profile);
                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: b.pastelBlue.withValues(alpha: 0.25),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                          border: Border(bottom: BorderSide(color: b.slate, width: 1.2)),
                        ),
                        child: Text(
                          paradigm.label(),
                          style: t.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ),
                      if (conj.isDefective && matching.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text('— (non attesté pour ce verbe défectif)'),
                        )
                      else
                        ..._buildParadigmRows(context, paradigm, slots, matching, conj, profile),
                    ],
                  ),
                );
              }),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeaderCard(
    BuildContext context,
    ConjugationRecord conj,
    LanguageRecord lang,
  ) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: b.cardSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: b.slate, width: 1.5),
        boxShadow: [
          BoxShadow(color: b.slate, offset: const Offset(3, 3), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  conj.lemma,
                  style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              _badge(context, lang.code.toUpperCase(), b.pastelYellow),
              if (!conj.isPublished) ...[
                const SizedBox(width: 6),
                _badge(context, 'BROUILLON', b.pastelRed),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              if (conj.group != null) _badge(context, conj.group!, b.chalk),
              if (conj.auxiliaries.isNotEmpty)
                _badge(context, 'Aux : ${conj.auxiliaries.join(' / ')}', b.pastelBlue.withValues(alpha: 0.3)),
              if (conj.isPronominal)
                _badge(
                  context,
                  conj.reflexiveCase != null
                      ? 'Pronominal (${conj.reflexiveCase})'
                      : 'Pronominal',
                  b.pastelMint.withValues(alpha: 0.4),
                ),
              if (conj.isIrregular) _badge(context, 'Irrégulier', b.pastelRed.withValues(alpha: 0.4)),
              if (conj.isDefective) _badge(context, 'Défectif', b.pastelYellow.withValues(alpha: 0.5)),
            ],
          ),
          if (conj.noteText().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(conj.noteText(), style: t.bodyMedium),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildParadigmRows(
    BuildContext context,
    VerbParadigm paradigm,
    List<Map<String, dynamic>> slots,
    List<ConjugationForm> forms,
    ConjugationRecord conj,
    GrammarProfile profile,
  ) {
    final b = context.bauhaus;
    if (conj.auxiliaries.length > 1 && paradigm.kind == 'compound') {
      return forms.map((f) => _formTile(context, f, profile, showAux: true)).toList();
    }

    final rows = <Widget>[];
    for (final slot in slots) {
      final slotKey = ConjugationForm.buildSlotKey(paradigm.mood, paradigm.tense, paradigm, slot);
      final match = forms.where((f) => f.slotKey(paradigm) == slotKey).toList();
      if (match.isEmpty) {
        if (conj.isDefective) {
          rows.add(
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: b.lineGrey)),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      slot.values.join(' '),
                      style: TextStyle(color: b.slate.withValues(alpha: 0.6), fontSize: 12),
                    ),
                  ),
                  const Text('—', style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          );
        }
        continue;
      }
      for (final f in match) {
        rows.add(_formTile(context, f, profile));
      }
    }
    return rows;
  }

  Widget _formTile(
    BuildContext context,
    ConjugationForm f,
    GrammarProfile profile, {
    bool showAux = false,
  }) {
    final b = context.bauhaus;
    final display = PronounRenderer.renderSubjectWithForm(f, profile);
    final note = f.exceptionNote?['fr'];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: f.needsReview ? b.pastelRed.withValues(alpha: 0.15) : null,
        border: Border(bottom: BorderSide(color: b.lineGrey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  display,
                  style: TextStyle(
                    fontWeight: f.isIrregular ? FontWeight.w800 : FontWeight.w600,
                    fontSize: 15,
                    color: b.slate,
                  ),
                ),
              ),
              if (showAux && f.auxiliary != null)
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: _badge(context, f.auxiliary!, b.chalk),
                ),
              if (f.isIrregular) _badge(context, 'IRR', b.pastelRed.withValues(alpha: 0.35)),
              if (f.needsReview) ...[
                const SizedBox(width: 4),
                _badge(context, 'À RELIRE', b.pastelRed),
              ],
            ],
          ),
          if (f.variants.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                'Variantes : ${f.variants.join(', ')}',
                style: TextStyle(fontSize: 12, color: b.slate.withValues(alpha: 0.7)),
              ),
            ),
          if (note != null && note.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                note,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: b.slate.withValues(alpha: 0.8),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _badge(BuildContext context, String text, Color bg) {
    final b = context.bauhaus;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: b.slate, width: 1),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: b.slate),
      ),
    );
  }
}
