import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../application/referentiel_controllers.dart';
import '../domain/declension.dart';
import '../domain/grammar_profile.dart';

enum _ReferentielSection { lessons, conjugations, declensions }

class ReferentielScreen extends ConsumerStatefulWidget {
  const ReferentielScreen({super.key});

  @override
  ConsumerState<ReferentielScreen> createState() => _ReferentielScreenState();
}

class _ReferentielScreenState extends ConsumerState<ReferentielScreen> {
  _ReferentielSection _section = _ReferentielSection.lessons;
  String _search = '';
  bool _onlyIrregular = false;
  DeclensionPos? _posFilter;

  @override
  Widget build(BuildContext context) {
    final b = context.bauhaus;
    final langsAsync = ref.watch(referentielLanguagesProvider);
    final activeLangAsync = ref.watch(activeLanguageRecordProvider);
    final isStudio = ref.watch(referentielStudioModeProvider);

    final activeLang = activeLangAsync.valueOrNull;
    final hasDeclensions = activeLang?.grammarProfile.hasDeclensions ?? false;
    final effectiveSection =
        (!hasDeclensions && _section == _ReferentielSection.declensions)
            ? _ReferentielSection.lessons
            : _section;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: b.pastelYellow,
                shape: BoxShape.circle,
                border: Border.all(color: b.slate, width: 1),
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'RÉFÉRENTIEL',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 0.5, fontSize: 16),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 4),
            child: FilterChip(
              avatar: Icon(
                isStudio ? Icons.edit : Icons.school_outlined,
                size: 15,
                color: b.slate,
              ),
              label: Text(isStudio ? 'STUDIO' : 'APPRENANT'),
              selected: isStudio,
              selectedColor: b.pastelYellow,
              onSelected: (v) =>
                  ref.read(referentielStudioModeProvider.notifier).setEnabled(v),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Paramètres',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Language selector bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: b.cardSurface,
              border: Border(bottom: BorderSide(color: b.slate, width: 1.5)),
            ),
            child: langsAsync.when(
              loading: () => const SizedBox(height: 32),
              error: (_, __) => const SizedBox.shrink(),
              data: (langs) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: langs.map((lang) {
                    final selected = activeLang?.code == lang.code;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('${lang.code.toUpperCase()} · ${lang.displayName()}'),
                        selected: selected,
                        selectedColor: b.pastelBlue,
                        onSelected: (_) {
                          ref.read(activeReferentielLangProvider.notifier).select(lang.code);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),

          // Sub-tabs (Leçons / Conjugaisons / Déclinaisons si has_declensions)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
            child: Row(
              children: [
                _subTabButton(
                  context,
                  label: 'LEÇONS',
                  selected: effectiveSection == _ReferentielSection.lessons,
                  accent: b.pastelYellow,
                  onTap: () => setState(() => _section = _ReferentielSection.lessons),
                ),
                const SizedBox(width: 8),
                _subTabButton(
                  context,
                  label: 'CONJUGAISONS',
                  selected: effectiveSection == _ReferentielSection.conjugations,
                  accent: b.pastelBlue,
                  onTap: () => setState(() => _section = _ReferentielSection.conjugations),
                ),
                if (hasDeclensions) ...[
                  const SizedBox(width: 8),
                  _subTabButton(
                    context,
                    label: 'DÉCLINAISONS',
                    selected: effectiveSection == _ReferentielSection.declensions,
                    accent: b.pastelMint,
                    onTap: () => setState(() => _section = _ReferentielSection.declensions),
                  ),
                ],
              ],
            ),
          ),

          // Studio quick toolbar
          if (isStudio)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.add, size: 16),
                      label: Text(
                        switch (effectiveSection) {
                          _ReferentielSection.lessons => 'NOUVELLE LEÇON',
                          _ReferentielSection.conjugations => 'NOUVEAU VERBE',
                          _ReferentielSection.declensions => 'NOUVELLE DÉCLINAISON',
                        },
                        style: const TextStyle(fontSize: 11),
                      ),
                      onPressed: () {
                        switch (effectiveSection) {
                          case _ReferentielSection.lessons:
                            context.push('/referentiel/studio/lesson');
                          case _ReferentielSection.conjugations:
                            context.push('/referentiel/studio/conjugation');
                          case _ReferentielSection.declensions:
                            context.push('/referentiel/studio/declension');
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.code, size: 16),
                    label: const Text('JSON & IA', style: TextStyle(fontSize: 11)),
                    onPressed: () => context.push('/referentiel/studio/import'),
                  ),
                ],
              ),
            ),

          // Search + filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      isDense: true,
                      hintText: 'Filtrer...',
                      prefixIcon: Icon(Icons.search, size: 18),
                    ),
                    onChanged: (v) => setState(() => _search = v.trim().toLowerCase()),
                  ),
                ),
                if (effectiveSection != _ReferentielSection.lessons) ...[
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('IRR.'),
                    selected: _onlyIrregular,
                    selectedColor: b.pastelRed,
                    onSelected: (v) => setState(() => _onlyIrregular = v),
                  ),
                ],
              ],
            ),
          ),

          if (effectiveSection == _ReferentielSection.declensions && hasDeclensions)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('TOUS POS'),
                    selected: _posFilter == null,
                    onSelected: (_) => setState(() => _posFilter = null),
                  ),
                  const SizedBox(width: 6),
                  for (final pos in DeclensionPos.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: ChoiceChip(
                        label: Text(pos.code),
                        selected: _posFilter == pos,
                        onSelected: (on) => setState(() => _posFilter = on ? pos : null),
                      ),
                    ),
                ],
              ),
            ),

          Expanded(
            child: switch (effectiveSection) {
              _ReferentielSection.lessons => _buildLessonsList(context, isStudio),
              _ReferentielSection.conjugations => _buildConjugationsList(context, activeLang, isStudio),
              _ReferentielSection.declensions => _buildDeclensionsList(context, isStudio),
            },
          ),
        ],
      ),
    );
  }

  Widget _subTabButton(
    BuildContext context, {
    required String label,
    required bool selected,
    required Color accent,
    required VoidCallback onTap,
  }) {
    final b = context.bauhaus;
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 9),
          decoration: BoxDecoration(
            color: selected ? accent : b.cardSurface,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: b.slate, width: selected ? 2.0 : 1.2),
            boxShadow: selected
                ? [BoxShadow(color: b.slate, offset: const Offset(2, 2), blurRadius: 0)]
                : const [],
          ),
          child: Center(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                color: b.slate,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonsList(BuildContext context, bool isStudio) {
    final b = context.bauhaus;
    final lessonsAsync = ref.watch(referentielLessonsProvider);
    final progressMap = ref.watch(lessonProgressMapProvider).valueOrNull ?? const {};

    return lessonsAsync.when(
      loading: () => Center(child: CircularProgressIndicator(color: b.slate)),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (lessons) {
        final filtered = lessons.where((l) {
          if (_search.isEmpty) return true;
          return l.titleText().toLowerCase().contains(_search) ||
              l.slug.toLowerCase().contains(_search);
        }).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('Aucune leçon disponible pour cette langue.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final lesson = filtered[index];
            final prog = progressMap[lesson.id];
            return _cardItem(
              context,
              title: lesson.titleText(),
              subtitle:
                  '${lesson.level} · Ordre ${lesson.order} · ${lesson.blocks.length} bloc(s) · ${lesson.exercises.length} exercice(s)',
              badges: [
                if (prog != null)
                  _miniBadge(context, '${(prog.score * 100).round()}%', b.pastelMint),
                if (!lesson.isPublished)
                  _miniBadge(context, 'BROUILLON', b.pastelRed),
              ],
              onTap: () {
                if (isStudio) {
                  context.push('/referentiel/studio/lesson', extra: lesson);
                } else {
                  context.push('/referentiel/lesson/${lesson.id}');
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildConjugationsList(
    BuildContext context,
    LanguageRecord? lang,
    bool isStudio,
  ) {
    final b = context.bauhaus;
    final conjAsync = ref.watch(referentielConjugationsProvider);

    return conjAsync.when(
      loading: () => Center(child: CircularProgressIndicator(color: b.slate)),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (list) {
        final filtered = list.where((c) {
          if (_onlyIrregular && !c.isIrregular) return false;
          if (_search.isEmpty) return true;
          return c.lemma.toLowerCase().contains(_search);
        }).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('Aucune conjugaison trouvée.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final c = filtered[index];
            final subtitleParts = <String>[
              if (c.group != null) c.group!,
              if (c.auxiliaries.isNotEmpty) 'aux: ${c.auxiliaries.join('/')}',
              '${c.forms.length} forme(s)',
            ];
            return _cardItem(
              context,
              title: c.lemma,
              subtitle: subtitleParts.join(' · '),
              badges: [
                if (c.isIrregular) _miniBadge(context, 'IRR', b.pastelRed.withValues(alpha: 0.4)),
                if (c.isDefective) _miniBadge(context, 'DÉF', b.pastelYellow),
                if (c.isPronominal) _miniBadge(context, 'PRON', b.pastelMint.withValues(alpha: 0.4)),
                if (c.hasNeedsReview) _miniBadge(context, 'À RELIRE', b.pastelRed),
                if (!c.isPublished) _miniBadge(context, 'BROUILLON', b.chalk),
              ],
              onTap: () {
                if (isStudio) {
                  context.push('/referentiel/studio/conjugation', extra: c);
                } else {
                  context.push('/referentiel/conjugation/${c.id}');
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _buildDeclensionsList(BuildContext context, bool isStudio) {
    final b = context.bauhaus;
    final declAsync = ref.watch(referentielDeclensionsProvider);

    return declAsync.when(
      loading: () => Center(child: CircularProgressIndicator(color: b.slate)),
      error: (e, _) => Center(child: Text('Erreur : $e')),
      data: (list) {
        final filtered = list.where((d) {
          if (_onlyIrregular && !d.isIrregular) return false;
          if (_posFilter != null && d.pos != _posFilter) return false;
          if (_search.isEmpty) return true;
          return d.lemma.toLowerCase().contains(_search);
        }).toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('Aucune déclinaison trouvée.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final d = filtered[index];
            final subtitleParts = <String>[
              d.pos.code,
              if (d.gender != null) d.gender!,
              if (d.declensionClass != null) d.declensionClass!,
              '${d.forms.length} forme(s)',
            ];
            return _cardItem(
              context,
              title: d.lemma,
              subtitle: subtitleParts.join(' · '),
              badges: [
                _miniBadge(context, d.pos.code, b.pastelBlue.withValues(alpha: 0.3)),
                if (d.isIrregular) _miniBadge(context, 'IRR', b.pastelRed.withValues(alpha: 0.4)),
                if (d.isInvariable) _miniBadge(context, 'INV', b.pastelMint.withValues(alpha: 0.4)),
                if (d.hasNeedsReview) _miniBadge(context, 'À RELIRE', b.pastelRed),
                if (!d.isPublished) _miniBadge(context, 'BROUILLON', b.chalk),
              ],
              onTap: () {
                if (isStudio) {
                  context.push('/referentiel/studio/declension', extra: d);
                } else {
                  context.push('/referentiel/declension/${d.id}');
                }
              },
            );
          },
        );
      },
    );
  }

  Widget _cardItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required List<Widget> badges,
    required VoidCallback onTap,
  }) {
    final b = context.bauhaus;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: b.cardSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: b.slate, width: 1.5),
        boxShadow: [BoxShadow(color: b.slate, offset: const Offset(2, 2), blurRadius: 0)],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16)),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 12, color: b.slate.withValues(alpha: 0.7)),
                    ),
                    if (badges.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Wrap(spacing: 6, runSpacing: 4, children: badges),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: b.slate),
            ],
          ),
        ),
      ),
    );
  }

  Widget _miniBadge(BuildContext context, String label, Color bg) {
    final b = context.bauhaus;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: b.slate, width: 1),
      ),
      child: Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800)),
    );
  }
}
