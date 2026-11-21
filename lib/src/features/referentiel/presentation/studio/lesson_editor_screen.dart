import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/theme/bauhaus_theme.dart';
import '../../application/referentiel_controllers.dart';
import '../../domain/conjugation.dart';
import '../../domain/declension.dart';
import '../../domain/grammar_lesson.dart';
import '../../domain/grammar_profile.dart';
import '../lesson_detail_screen.dart';

class LessonEditorScreen extends ConsumerStatefulWidget {
  final GrammarLessonRecord? initialRecord;

  const LessonEditorScreen({super.key, this.initialRecord});

  @override
  ConsumerState<LessonEditorScreen> createState() => _LessonEditorScreenState();
}

class _LessonEditorScreenState extends ConsumerState<LessonEditorScreen> {
  late TextEditingController _titleCtrl;
  late TextEditingController _slugCtrl;
  late TextEditingController _orderCtrl;
  late String _level;
  late bool _isPublished;
  late List<int> _linkedVerbIds;
  late List<TargetTense> _targetTenses;
  late List<int> _linkedDeclIds;
  late List<String> _targetCases;
  late List<LessonBlock> _blocks;
  late List<LessonExercise> _exercises;

  @override
  void initState() {
    super.initState();
    final r = widget.initialRecord;
    _titleCtrl = TextEditingController(text: r?.titleText() ?? '');
    _slugCtrl = TextEditingController(text: r?.slug ?? '');
    _orderCtrl = TextEditingController(text: '${r?.order ?? 1}');
    _level = r?.level ?? 'A1';
    _isPublished = r?.isPublished ?? false;
    _linkedVerbIds = List<int>.from(r?.linkedVerbIds ?? const []);
    _targetTenses = List<TargetTense>.from(r?.targetTenses ?? const []);
    _linkedDeclIds = List<int>.from(r?.linkedDeclensionIds ?? const []);
    _targetCases = List<String>.from(r?.targetCases ?? const []);
    _blocks = List<LessonBlock>.from(r?.blocks ?? const []);
    _exercises = List<LessonExercise>.from(r?.exercises ?? const []);
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _slugCtrl.dispose();
    _orderCtrl.dispose();
    super.dispose();
  }

  GrammarLessonRecord _buildDraft(LanguageRecord lang) {
    return GrammarLessonRecord(
      id: widget.initialRecord?.id ?? 0,
      langId: lang.id,
      langCode: lang.code,
      slug: _slugCtrl.text.trim(),
      level: _level,
      order: int.tryParse(_orderCtrl.text.trim()) ?? 1,
      title: {'fr': _titleCtrl.text.trim()},
      prerequisiteIds: widget.initialRecord?.prerequisiteIds ?? const [],
      linkedVerbIds: _linkedVerbIds,
      targetTenses: _targetTenses,
      linkedDeclensionIds: _linkedDeclIds,
      targetCases: _targetCases,
      blocks: _blocks,
      exercises: _exercises,
      isPublished: _isPublished,
    );
  }

  @override
  Widget build(BuildContext context) {
    final langAsync = ref.watch(activeLanguageRecordProvider);
    final verbsAsync = ref.watch(referentielConjugationsProvider);
    final declsAsync = ref.watch(referentielDeclensionsProvider);
    final b = context.bauhaus;

    return langAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('ÉDITEUR LEÇON')),
        body: Center(child: CircularProgressIndicator(color: b.slate)),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur : $e'))),
      data: (lang) {
        if (lang == null) {
          return const Scaffold(body: Center(child: Text('Aucune langue active.')));
        }
        final profile = lang.grammarProfile;
        final verbs = verbsAsync.valueOrNull ?? const <ConjugationRecord>[];
        final decls = declsAsync.valueOrNull ?? const <DeclensionRecord>[];

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'ÉDITEUR LEÇON',
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.visibility_outlined),
                tooltip: 'Aperçu Élève',
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => LessonDetailScreen(
                        lessonId: widget.initialRecord?.id ?? 0,
                        previewLesson: _buildDraft(lang),
                      ),
                    ),
                  );
                },
              ),
              TextButton.icon(
                icon: const Icon(Icons.save_outlined),
                label: const Text('ENREGISTRER'),
                onPressed: () => _save(lang),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: b.cardSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: b.slate, width: 1.5),
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _titleCtrl,
                      decoration: const InputDecoration(labelText: 'Titre (FR)'),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _slugCtrl,
                      decoration: const InputDecoration(labelText: 'Slug ASCII (ex: subjonctif-present)'),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            initialValue: _level,
                            decoration: const InputDecoration(labelText: 'Niveau'),
                            items: const ['A1', 'A2', 'B1', 'B2', 'C1', 'C2']
                                .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _level = v);
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _orderCtrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(labelText: 'Ordre'),
                          ),
                        ),
                      ],
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Publié (visible aux apprenants)'),
                      value: _isPublished,
                      onChanged: (v) => setState(() => _isPublished = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Liaisons optionnelles : verbes
              Container(
                decoration: BoxDecoration(
                  color: b.cardSurface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: b.slate, width: 1.5),
                ),
                child: ExpansionTile(
                  title: Text(
                    'Verbes liés (${_linkedVerbIds.length}) & Temps cibles',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  childrenPadding: const EdgeInsets.all(12),
                  children: [
                    Wrap(
                      spacing: 6,
                      children: verbs.map((v) {
                        final selected = _linkedVerbIds.contains(v.id);
                        return FilterChip(
                          label: Text(v.lemma),
                          selected: selected,
                          onSelected: (on) {
                            setState(() {
                              if (on) {
                                _linkedVerbIds.add(v.id);
                              } else {
                                _linkedVerbIds.remove(v.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: profile.paradigms.map((p) {
                        final tt = TargetTense(mood: p.mood, tense: p.tense);
                        final selected = _targetTenses.contains(tt);
                        return FilterChip(
                          label: Text(p.label()),
                          selected: selected,
                          onSelected: (on) {
                            setState(() {
                              if (on) {
                                _targetTenses.add(tt);
                              } else {
                                _targetTenses.remove(tt);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              if (profile.hasDeclensions) ...[
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: b.cardSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: b.slate, width: 1.5),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      'Déclinaisons liées (${_linkedDeclIds.length}) & Cas cibles',
                      style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                    childrenPadding: const EdgeInsets.all(12),
                    children: [
                      Wrap(
                        spacing: 6,
                        children: decls.map((d) {
                          final selected = _linkedDeclIds.contains(d.id);
                          return FilterChip(
                            label: Text('${d.lemma} (${d.pos.code})'),
                            selected: selected,
                            onSelected: (on) {
                              setState(() {
                                if (on) {
                                  _linkedDeclIds.add(d.id);
                                } else {
                                  _linkedDeclIds.remove(d.id);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 6,
                        children: profile.cases.map((c) {
                          final selected = _targetCases.contains(c);
                          return FilterChip(
                            label: Text(profile.caseLabel(c)),
                            selected: selected,
                            onSelected: (on) {
                              setState(() {
                                if (on) {
                                  _targetCases.add(c);
                                } else {
                                  _targetCases.remove(c);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('BLOCS PÉDAGOGIQUES', style: TextStyle(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('AJOUTER BLOC'),
                    onPressed: _addBlockDialog,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._blocks.asMap().entries.map((entry) {
                final idx = entry.key;
                final block = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: b.cardSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: b.slate, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '[${block.type.labelFr}] ${block.titleText()}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'id: ${block.id}',
                              style: TextStyle(fontSize: 11, color: b.slate.withValues(alpha: 0.6)),
                            ),
                          ],
                        ),
                      ),
                      if (idx > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_upward, size: 18),
                          onPressed: () => setState(() {
                            final item = _blocks.removeAt(idx);
                            _blocks.insert(idx - 1, item);
                          }),
                        ),
                      if (idx + 1 < _blocks.length)
                        IconButton(
                          icon: const Icon(Icons.arrow_downward, size: 18),
                          onPressed: () => setState(() {
                            final item = _blocks.removeAt(idx);
                            _blocks.insert(idx + 1, item);
                          }),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () => setState(() => _blocks.removeAt(idx)),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('EXERCICES', style: TextStyle(fontWeight: FontWeight.w800)),
                  const Spacer(),
                  OutlinedButton.icon(
                    icon: const Icon(Icons.add, size: 16),
                    label: const Text('AJOUTER EXERCICE'),
                    onPressed: _addExerciseDialog,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ..._exercises.asMap().entries.map((entry) {
                final idx = entry.key;
                final ex = entry.value;
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: b.cardSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: b.slate, width: 1.2),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '[${ex.type.labelFr}] ${ex.promptText()}',
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'Réponse : ${ex.answer} · id: ${ex.id}',
                              style: TextStyle(fontSize: 11, color: b.slate.withValues(alpha: 0.65)),
                            ),
                          ],
                        ),
                      ),
                      if (idx > 0)
                        IconButton(
                          icon: const Icon(Icons.arrow_upward, size: 18),
                          onPressed: () => setState(() {
                            final item = _exercises.removeAt(idx);
                            _exercises.insert(idx - 1, item);
                          }),
                        ),
                      if (idx + 1 < _exercises.length)
                        IconButton(
                          icon: const Icon(Icons.arrow_downward, size: 18),
                          onPressed: () => setState(() {
                            final item = _exercises.removeAt(idx);
                            _exercises.insert(idx + 1, item);
                          }),
                        ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 18),
                        onPressed: () => setState(() => _exercises.removeAt(idx)),
                      ),
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

  Future<void> _addBlockDialog() async {
    var type = LessonBlockType.rule;
    final titleCtrl = TextEditingController();
    final contentCtrl = TextEditingController();
    final headersCtrl = TextEditingController(text: 'Col 1, Col 2');
    final rowsCtrl = TextEditingController(text: 'val 1, val 2');

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: const Text('Nouveau bloc'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<LessonBlockType>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: LessonBlockType.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(t.labelFr)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDlg(() => type = v);
                  },
                ),
                const SizedBox(height: 8),
                TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Titre')),
                const SizedBox(height: 8),
                if (type != LessonBlockType.table)
                  TextField(
                    controller: contentCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Contenu'),
                  )
                else ...[
                  TextField(
                    controller: headersCtrl,
                    decoration: const InputDecoration(labelText: 'En-têtes (séparés par virgule)'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: rowsCtrl,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Lignes (1 par ligne, colonnes par virgule)'),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ANNULER')),
            FilledButton(
              onPressed: () {
                final id = 'b_${DateTime.now().millisecondsSinceEpoch}';
                setState(() {
                  _blocks.add(
                    LessonBlock(
                      id: id,
                      type: type,
                      title: {'fr': titleCtrl.text.trim()},
                      content: type == LessonBlockType.table
                          ? const {}
                          : {'fr': contentCtrl.text.trim()},
                      headers: type == LessonBlockType.table
                          ? headersCtrl.text.split(',').map((s) => s.trim()).toList()
                          : const [],
                      rows: type == LessonBlockType.table
                          ? rowsCtrl.text
                              .split('\n')
                              .where((l) => l.trim().isNotEmpty)
                              .map((l) => l.split(',').map((c) => c.trim()).toList())
                              .toList()
                          : const [],
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('AJOUTER'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addExerciseDialog() async {
    var type = LessonExerciseType.cloze;
    final promptCtrl = TextEditingController();
    final beforeCtrl = TextEditingController();
    final afterCtrl = TextEditingController();
    final answerCtrl = TextEditingController();
    final distractorsCtrl = TextEditingController();
    final explanationCtrl = TextEditingController();

    await showDialog<void>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          title: const Text('Nouvel exercice'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<LessonExerciseType>(
                  initialValue: type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: LessonExerciseType.values
                      .map((t) => DropdownMenuItem(value: t, child: Text(t.labelFr)))
                      .toList(),
                  onChanged: (v) {
                    if (v != null) setDlg(() => type = v);
                  },
                ),
                const SizedBox(height: 8),
                TextField(controller: promptCtrl, decoration: const InputDecoration(labelText: 'Consigne')),
                const SizedBox(height: 8),
                TextField(controller: beforeCtrl, decoration: const InputDecoration(labelText: 'Avant le trou')),
                const SizedBox(height: 8),
                TextField(controller: afterCtrl, decoration: const InputDecoration(labelText: 'Après le trou')),
                const SizedBox(height: 8),
                TextField(controller: answerCtrl, decoration: const InputDecoration(labelText: 'Réponse attendue')),
                if (type == LessonExerciseType.qcm) ...[
                  const SizedBox(height: 8),
                  TextField(
                    controller: distractorsCtrl,
                    decoration: const InputDecoration(labelText: 'Distracteurs (séparés par virgule)'),
                  ),
                ],
                const SizedBox(height: 8),
                TextField(controller: explanationCtrl, decoration: const InputDecoration(labelText: 'Explication')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('ANNULER')),
            FilledButton(
              onPressed: () {
                if (answerCtrl.text.trim().isEmpty) return;
                final id = 'ex_${DateTime.now().millisecondsSinceEpoch}';
                setState(() {
                  _exercises.add(
                    LessonExercise(
                      id: id,
                      type: type,
                      prompt: {'fr': promptCtrl.text.trim()},
                      sentenceBefore: beforeCtrl.text,
                      sentenceAfter: afterCtrl.text,
                      answer: answerCtrl.text.trim(),
                      distractors: type == LessonExerciseType.qcm
                          ? distractorsCtrl.text
                              .split(',')
                              .map((s) => s.trim())
                              .where((s) => s.isNotEmpty)
                              .toList()
                          : const [],
                      explanation: {'fr': explanationCtrl.text.trim()},
                    ),
                  );
                });
                Navigator.pop(ctx);
              },
              child: const Text('AJOUTER'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(LanguageRecord lang) async {
    if (_slugCtrl.text.trim().isEmpty) return;
    final repo = ref.read(referentielRepositoryProvider);
    await repo.upsertLesson(_buildDraft(lang));
    ref.invalidate(referentielLessonsProvider);
    if (mounted) context.pop();
  }
}
