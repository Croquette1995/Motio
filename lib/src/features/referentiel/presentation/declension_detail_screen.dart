import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../../vocabulary/presentation/vocabulary_controller.dart';
import '../domain/declension.dart';
import '../domain/grammar_profile.dart';

class DeclensionDetailScreen extends ConsumerStatefulWidget {
  final int declensionId;

  const DeclensionDetailScreen({super.key, required this.declensionId});

  @override
  ConsumerState<DeclensionDetailScreen> createState() => _DeclensionDetailScreenState();
}

class _DeclensionDetailScreenState extends ConsumerState<DeclensionDetailScreen> {
  String _selectedDefiniteness = 'DEF';

  @override
  Widget build(BuildContext context) {
    final repo = ref.watch(referentielRepositoryProvider);
    final bridge = ref.watch(vocabularyBridgeServiceProvider);
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return FutureBuilder<(DeclensionRecord?, LanguageRecord?)>(
      future: () async {
        final decl = await repo.getDeclensionById(widget.declensionId);
        if (decl == null) return (null, null);
        final lang = await repo.getLanguageById(decl.langId);
        return (decl, lang);
      }(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('DÉCLINAISON')),
            body: Center(child: CircularProgressIndicator(color: b.slate)),
          );
        }

        final decl = snapshot.data!.$1;
        final lang = snapshot.data!.$2;
        if (decl == null || lang == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('DÉCLINAISON')),
            body: const Center(child: Text('Fiche de déclinaison introuvable.')),
          );
        }

        final profile = lang.grammarProfile;
        final paradigm = profile.findDeclensionParadigm(decl.pos.code);
        final hasDefinitenessFilter =
            decl.pos == DeclensionPos.adj &&
            (paradigm?.dimensions.contains('definiteness') ?? false);

        final visibleForms = hasDefinitenessFilter
            ? decl.forms.where((f) => f.definiteness == _selectedDefiniteness).toList()
            : decl.forms;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              '${decl.lemma} (${decl.pos.code})',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: 'Éditer dans le Studio',
                onPressed: () => context.push('/referentiel/studio/declension', extra: decl),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
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
                            decl.lemma,
                            style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                          ),
                        ),
                        _badge(context, decl.pos.code, b.pastelYellow),
                        if (!decl.isPublished) ...[
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
                        if (decl.gender != null) _badge(context, decl.gender!, b.pastelBlue.withValues(alpha: 0.3)),
                        if (decl.declensionClass != null)
                          _badge(context, decl.declensionClass!, b.chalk),
                        if (decl.isIrregular)
                          _badge(context, 'Irrégulier', b.pastelRed.withValues(alpha: 0.35)),
                        if (decl.isInvariable)
                          _badge(context, 'Invariable', b.pastelMint.withValues(alpha: 0.4)),
                      ],
                    ),
                    if (decl.noteText().isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Text(decl.noteText(), style: t.bodyMedium),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              FutureBuilder(
                future: bridge.findWordForMorphology(
                  langCode: decl.langCode,
                  lemma: decl.lemma,
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
              if (hasDefinitenessFilter) ...[
                Row(
                  children: [
                    for (final entry in const [
                      ('DEF', 'Faible (DEF)'),
                      ('INDEF', 'Mixte (INDEF)'),
                      ('ZERO', 'Forte (ZERO)'),
                    ])
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: ChoiceChip(
                            label: Text(entry.$2),
                            selected: _selectedDefiniteness == entry.$1,
                            selectedColor: b.pastelYellow,
                            onSelected: (_) => setState(() => _selectedDefiniteness = entry.$1),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
              Container(
                decoration: BoxDecoration(
                  color: b.cardSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: b.slate, width: 1.5),
                  boxShadow: [
                    BoxShadow(color: b.slate, offset: const Offset(2, 2), blurRadius: 0),
                  ],
                ),
                child: Column(
                  children: visibleForms.map((f) {
                    final caseLabel =
                        f.caseCode != null ? profile.caseLabel(f.caseCode!) : '';
                    final dims = [
                      if (caseLabel.isNotEmpty) caseLabel,
                      if (f.number != null) f.number!,
                      if (f.gender != null) f.gender!,
                      if (!hasDefinitenessFilter && f.definiteness != null) f.definiteness!,
                    ].join(' · ');
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
                                flex: 3,
                                child: Text(
                                  dims,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: b.slate.withValues(alpha: 0.7),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(
                                  f.form,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: f.isIrregular ? FontWeight.w800 : FontWeight.w600,
                                    color: b.slate,
                                  ),
                                ),
                              ),
                              if (f.isIrregular)
                                _badge(context, 'IRR', b.pastelRed.withValues(alpha: 0.35)),
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
                  }).toList(),
                ),
              ),
            ],
          ),
        );
      },
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
