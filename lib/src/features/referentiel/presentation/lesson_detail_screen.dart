import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/theme/bauhaus_theme.dart';
import '../application/pronoun_renderer.dart';
import '../domain/conjugation.dart';
import '../domain/declension.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_profile.dart';

class LessonDetailScreen extends ConsumerWidget {
  final int lessonId;
  final GrammarLessonRecord? previewLesson;

  const LessonDetailScreen({
    super.key,
    required this.lessonId,
    this.previewLesson,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repo = ref.watch(referentielRepositoryProvider);
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;

    return FutureBuilder<(GrammarLessonRecord?, LanguageRecord?, List<ConjugationRecord>, List<DeclensionRecord>)>(
      future: () async {
        final lesson = previewLesson ?? await repo.getLessonById(lessonId);
        if (lesson == null) return (null, null, <ConjugationRecord>[], <DeclensionRecord>[]);
        final lang = await repo.getLanguageById(lesson.langId);
        final verbs = <ConjugationRecord>[];
        for (final id in lesson.linkedVerbIds) {
          final v = await repo.getConjugationById(id);
          if (v != null) verbs.add(v);
        }
        final decls = <DeclensionRecord>[];
        for (final id in lesson.linkedDeclensionIds) {
          final d = await repo.getDeclensionById(id);
          if (d != null) decls.add(d);
        }
        return (lesson, lang, verbs, decls);
      }(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            appBar: AppBar(title: const Text('LEÇON')),
            body: Center(child: CircularProgressIndicator(color: b.slate)),
          );
        }

        final lesson = snapshot.data!.$1;
        final lang = snapshot.data!.$2;
        final verbs = snapshot.data!.$3;
        final decls = snapshot.data!.$4;

        if (lesson == null || lang == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('LEÇON')),
            body: const Center(child: Text('Leçon introuvable.')),
          );
        }

        final profile = lang.grammarProfile;
        final isPreview = previewLesson != null;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              isPreview ? 'APERÇU ÉLÈVE' : 'LEÇON ${lesson.level}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            actions: [
              if (!isPreview)
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  tooltip: 'Éditer dans le Studio',
                  onPressed: () => context.push('/referentiel/studio/lesson', extra: lesson),
                ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
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
                        _pill(context, lang.code.toUpperCase(), b.pastelYellow),
                        const SizedBox(width: 6),
                        _pill(context, lesson.level, b.pastelBlue.withValues(alpha: 0.35)),
                        if (isPreview) ...[
                          const SizedBox(width: 6),
                          _pill(context, 'APERÇU', b.pastelMint),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      lesson.titleText(),
                      style: t.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              ...lesson.blocks.map((block) => _buildBlockCard(context, block)),
              if (verbs.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'CONJUGAISONS LIÉES',
                  style: t.labelLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                ...verbs.map((v) => _buildLinkedVerbTable(context, v, lesson.targetTenses, profile)),
              ],
              if (decls.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'DÉCLINAISONS LIÉES',
                  style: t.labelLarge?.copyWith(fontWeight: FontWeight.w800, letterSpacing: 1),
                ),
                const SizedBox(height: 8),
                ...decls.map((d) => _buildLinkedDeclTable(context, d, lesson.targetCases, profile)),
              ],
              const SizedBox(height: 24),
            ],
          ),
          bottomNavigationBar:
              (lesson.exercises.isNotEmpty || verbs.isNotEmpty || decls.isNotEmpty)
                  ? SafeArea(
                      top: false,
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
                        decoration: BoxDecoration(
                          color: b.cardSurface,
                          border: Border(top: BorderSide(color: b.slate, width: 1.5)),
                        ),
                        child: FilledButton.icon(
                          icon: const Icon(Icons.play_arrow_rounded),
                          label: const Text("S'ENTRAÎNER"),
                          onPressed: () {
                            context.push(
                              '/referentiel/lesson/${lesson.id}/practice',
                              extra: isPreview ? lesson : null,
                            );
                          },
                        ),
                      ),
                    )
                  : null,
        );
      },
    );
  }

  Widget _buildBlockCard(BuildContext context, LessonBlock block) {
    final b = context.bauhaus;
    final t = Theme.of(context).textTheme;
    final bg = switch (block.type) {
      LessonBlockType.exception => b.pastelRed.withValues(alpha: 0.16),
      LessonBlockType.tip => b.pastelYellow.withValues(alpha: 0.2),
      LessonBlockType.rule => b.cardSurface,
      LessonBlockType.table => b.cardSurface,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: b.slate, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _pill(
                context,
                block.type.labelFr.toUpperCase(),
                block.type == LessonBlockType.exception ? b.pastelRed : b.pastelBlue.withValues(alpha: 0.3),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  block.titleText(),
                  style: t.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          if (block.type != LessonBlockType.table && block.contentText().isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(block.contentText(), style: t.bodyMedium?.copyWith(height: 1.4)),
          ],
          if (block.examples.isNotEmpty) ...[
            const SizedBox(height: 10),
            ...block.examples.map(
              (ex) => Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: b.cardSurface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: b.lineGrey, width: 1.2),
                ),
                child: _highlightedExample(context, ex),
              ),
            ),
          ],
          if (block.type == LessonBlockType.table && block.headers.isNotEmpty) ...[
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Table(
                defaultColumnWidth: const IntrinsicColumnWidth(),
                border: TableBorder.all(color: b.slate, width: 1.2),
                children: [
                  TableRow(
                    decoration: BoxDecoration(color: b.pastelYellow.withValues(alpha: 0.4)),
                    children: block.headers
                        .map(
                          (h) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            child: Text(h, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                          ),
                        )
                        .toList(),
                  ),
                  ...block.rows.map(
                    (row) => TableRow(
                      children: row
                          .map(
                            (cell) => Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                              child: Text(cell, style: const TextStyle(fontSize: 13)),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _highlightedExample(BuildContext context, LessonExample ex) {
    final b = context.bauhaus;
    final hl = ex.highlight;
    if (hl == null || hl.isEmpty || !ex.sentence.contains(hl)) {
      return Text(ex.sentence, style: const TextStyle(fontSize: 13));
    }
    final idx = ex.sentence.indexOf(hl);
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 13, color: b.slate),
        children: [
          TextSpan(text: ex.sentence.substring(0, idx)),
          TextSpan(
            text: hl,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              backgroundColor: b.pastelYellow.withValues(alpha: 0.65),
            ),
          ),
          TextSpan(text: ex.sentence.substring(idx + hl.length)),
        ],
      ),
    );
  }

  Widget _buildLinkedVerbTable(
    BuildContext context,
    ConjugationRecord verb,
    List<TargetTense> targetTenses,
    GrammarProfile profile,
  ) {
    final b = context.bauhaus;
    final filtered = verb.forms.where((f) {
      if (targetTenses.isEmpty) return true;
      return targetTenses.any((t) => t.mood == f.mood && t.tense == f.tense);
    }).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: b.cardSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: b.slate, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push('/referentiel/conjugation/${verb.id}'),
            child: Row(
              children: [
                Text(verb.lemma, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15)),
                const Spacer(),
                const Icon(Icons.open_in_new, size: 16),
              ],
            ),
          ),
          const Divider(),
          ...filtered.map(
            (f) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Text(
                '${f.mood} ${f.tense} : ${PronounRenderer.renderSubjectWithForm(f, profile)}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLinkedDeclTable(
    BuildContext context,
    DeclensionRecord decl,
    List<String> targetCases,
    GrammarProfile profile,
  ) {
    final b = context.bauhaus;
    final filtered = decl.forms.where((f) {
      if (targetCases.isEmpty) return true;
      return f.caseCode != null && targetCases.contains(f.caseCode);
    }).toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: b.cardSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: b.slate, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => context.push('/referentiel/declension/${decl.id}'),
            child: Row(
              children: [
                Text(
                  '${decl.lemma} (${decl.pos.code})',
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
                ),
                const Spacer(),
                const Icon(Icons.open_in_new, size: 16),
              ],
            ),
          ),
          const Divider(),
          ...filtered.take(12).map((f) {
            final label = [
              if (f.caseCode != null) profile.caseLabel(f.caseCode!),
              if (f.number != null) f.number!,
              if (f.gender != null) f.gender!,
            ].join(' · ');
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  Expanded(
                    child: Text(label, style: TextStyle(fontSize: 12, color: b.slate.withValues(alpha: 0.7))),
                  ),
                  Text(f.form, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _pill(BuildContext context, String text, Color bg) {
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
