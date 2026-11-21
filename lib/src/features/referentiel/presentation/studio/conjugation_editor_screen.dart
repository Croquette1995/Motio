import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/theme/bauhaus_theme.dart';
import '../../application/referentiel_controllers.dart';
import '../../domain/conjugation.dart';
import '../../domain/grammar_profile.dart';

class ConjugationEditorScreen extends ConsumerStatefulWidget {
  final ConjugationRecord? initialRecord;

  const ConjugationEditorScreen({super.key, this.initialRecord});

  @override
  ConsumerState<ConjugationEditorScreen> createState() => _ConjugationEditorScreenState();
}

class _ConjugationEditorScreenState extends ConsumerState<ConjugationEditorScreen> {
  late TextEditingController _lemmaCtrl;
  late TextEditingController _noteCtrl;
  String? _group;
  List<String> _auxiliaries = [];
  bool _isPronominal = false;
  String? _reflexiveCase;
  bool _isIrregular = false;
  bool _isDefective = false;
  bool _isPublished = false;
  late List<ConjugationForm> _forms;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    final r = widget.initialRecord;
    _lemmaCtrl = TextEditingController(text: r?.lemma ?? '');
    _noteCtrl = TextEditingController(text: r?.noteText() ?? '');
    _group = r?.group;
    _auxiliaries = List<String>.from(r?.auxiliaries ?? const []);
    _isPronominal = r?.isPronominal ?? false;
    _reflexiveCase = r?.reflexiveCase;
    _isIrregular = r?.isIrregular ?? false;
    _isDefective = r?.isDefective ?? false;
    _isPublished = r?.isPublished ?? false;
    _forms = List<ConjugationForm>.from(r?.forms ?? const []);
  }

  @override
  void dispose() {
    _lemmaCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langAsync = ref.watch(activeLanguageRecordProvider);
    final b = context.bauhaus;

    return langAsync.when(
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('ÉDITEUR CONJUGAISON')),
        body: Center(child: CircularProgressIndicator(color: b.slate)),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur : $e'))),
      data: (lang) {
        if (lang == null) {
          return const Scaffold(body: Center(child: Text('Aucune langue active.')));
        }
        final profile = lang.grammarProfile;
        if (!_initialized) {
          if (!profile.hasVerbGroups) _group = null;
          if (!profile.hasAuxiliaries) _auxiliaries = [];
          if (!profile.hasPronominalVerbs) {
            _isPronominal = false;
            _reflexiveCase = null;
          }
          _initialized = true;
        }

        final hasNeedsReview = _forms.any((f) => f.needsReview);
        final expectedTotal = profile.paradigms.fold<int>(
          0,
          (acc, p) => acc + p.expectedSlots(profile).length,
        );
        final filledCount = _forms.where((f) => f.form.trim().isNotEmpty).length;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.initialRecord == null ? 'NOUVEAU VERBE' : 'ÉDITER ${widget.initialRecord!.lemma}',
              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
            ),
            actions: [
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _lemmaCtrl,
                      decoration: const InputDecoration(labelText: 'Lemme / Infinitif'),
                    ),
                    if (profile.hasVerbGroups) ...[
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        initialValue: profile.verbGroups.contains(_group) ? _group : null,
                        decoration: const InputDecoration(labelText: 'Groupe verbal'),
                        items: profile.verbGroups
                            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                            .toList(),
                        onChanged: (v) => setState(() => _group = v),
                      ),
                    ],
                    if (profile.hasAuxiliaries) ...[
                      const SizedBox(height: 12),
                      const Text('Auxiliaires', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: profile.auxiliaries.map((aux) {
                          final selected = _auxiliaries.contains(aux);
                          return FilterChip(
                            label: Text(aux),
                            selected: selected,
                            onSelected: (v) {
                              setState(() {
                                if (v) {
                                  _auxiliaries.add(aux);
                                } else {
                                  _auxiliaries.remove(aux);
                                }
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                    if (profile.hasPronominalVerbs) ...[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Verbe pronominal'),
                        value: _isPronominal,
                        onChanged: (v) => setState(() => _isPronominal = v),
                      ),
                      if (_isPronominal && profile.reflexiveCases.isNotEmpty)
                        DropdownButtonFormField<String>(
                          initialValue: profile.reflexiveCases.contains(_reflexiveCase)
                              ? _reflexiveCase
                              : null,
                          decoration: const InputDecoration(labelText: 'Cas réfléchi'),
                          items: profile.reflexiveCases
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => _reflexiveCase = v),
                        ),
                    ],
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Verbe irrégulier'),
                      value: _isIrregular,
                      onChanged: (v) => setState(() => _isIrregular = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Verbe défectif (cases absentes affichées —)'),
                      value: _isDefective,
                      onChanged: (v) => setState(() => _isDefective = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                        hasNeedsReview
                            ? 'Publié (verrouillé : formes à relire)'
                            : 'Publié (visible aux apprenants)',
                      ),
                      value: hasNeedsReview ? false : _isPublished,
                      onChanged: hasNeedsReview
                          ? null
                          : (v) => setState(() => _isPublished = v),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _noteCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(labelText: 'Note pédagogique (FR)'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    'FORMES PAR PARADIGME',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                  ),
                  const Spacer(),
                  Chip(label: Text('$filledCount / $expectedTotal')),
                ],
              ),
              const SizedBox(height: 8),
              ...profile.paradigms.map((p) => _buildParadigmSection(context, p, profile)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildParadigmSection(
    BuildContext context,
    VerbParadigm paradigm,
    GrammarProfile profile,
  ) {
    final b = context.bauhaus;
    final slots = paradigm.expectedSlots(profile);
    final sectionForms = _forms
        .where((f) => f.mood == paradigm.mood && f.tense == paradigm.tense)
        .toList();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: b.cardSurface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: b.slate, width: 1.5),
      ),
      child: ExpansionTile(
        title: Text(
          '${paradigm.label()} (${sectionForms.length}/${slots.length})',
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
        ),
        children: slots.map((slot) {
          final slotKey = ConjugationForm.buildSlotKey(paradigm.mood, paradigm.tense, paradigm, slot);
          final idx = _forms.indexWhere(
            (f) => f.mood == paradigm.mood && f.tense == paradigm.tense && f.slotKey(paradigm) == slotKey,
          );
          final existing = idx >= 0 ? _forms[idx] : null;
          final slotLabel = slot.isEmpty
              ? 'Forme'
              : slot.entries.map((e) => '${e.value}').join(' · ');

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: (existing?.needsReview ?? false)
                  ? b.pastelRed.withValues(alpha: 0.2)
                  : null,
              border: Border(top: BorderSide(color: b.lineGrey)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 84,
                      child: Text(
                        slotLabel,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
                      ),
                    ),
                    Expanded(
                      child: _isDefective && existing == null
                          ? Row(
                              children: [
                                const Text('—', style: TextStyle(fontWeight: FontWeight.w700)),
                                const Spacer(),
                                TextButton(
                                  onPressed: () => _upsertFormSlot(paradigm, slot, ''),
                                  child: const Text('Ajouter'),
                                ),
                              ],
                            )
                          : TextFormField(
                              initialValue: existing?.form ?? '',
                              decoration: const InputDecoration(
                                isDense: true,
                                hintText: 'Forme fléchie...',
                              ),
                              onChanged: (val) => _upsertFormSlot(paradigm, slot, val),
                            ),
                    ),
                    IconButton(
                      tooltip: 'Irrégulier',
                      icon: Icon(
                        Icons.bolt,
                        color: (existing?.isIrregular ?? false) ? b.pastelRed : b.lineGrey,
                      ),
                      onPressed: existing == null
                          ? null
                          : () => _toggleIrregular(idx),
                    ),
                    IconButton(
                      tooltip: 'À relire (needs_review)',
                      icon: Icon(
                        Icons.flag,
                        color: (existing?.needsReview ?? false) ? b.pastelRed : b.lineGrey,
                      ),
                      onPressed: existing == null
                          ? null
                          : () => _toggleNeedsReview(idx),
                    ),
                  ],
                ),
                if (existing != null && profile.hasPronominalVerbs && _isPronominal) ...[
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          initialValue: existing.pronoun ?? '',
                          decoration: const InputDecoration(isDense: true, labelText: 'Pronom'),
                          onChanged: (val) => _updatePronounBare(idx, pronoun: val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          initialValue: existing.bareForm ?? '',
                          decoration: const InputDecoration(isDense: true, labelText: 'Partie verbale'),
                          onChanged: (val) => _updatePronounBare(idx, bareForm: val),
                        ),
                      ),
                    ],
                  ),
                ],
                if (existing != null && existing.isIrregular) ...[
                  const SizedBox(height: 6),
                  TextFormField(
                    initialValue: existing.exceptionNote?['fr'] ?? '',
                    decoration: const InputDecoration(isDense: true, labelText: "Note d'exception (FR)"),
                    onChanged: (val) => _updateExceptionNote(idx, val),
                  ),
                ],
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _upsertFormSlot(VerbParadigm paradigm, Map<String, dynamic> slot, String value) {
    final slotKey = ConjugationForm.buildSlotKey(paradigm.mood, paradigm.tense, paradigm, slot);
    final idx = _forms.indexWhere(
      (f) => f.mood == paradigm.mood && f.tense == paradigm.tense && f.slotKey(paradigm) == slotKey,
    );
    setState(() {
      if (idx >= 0) {
        final prev = _forms[idx];
        _forms[idx] = ConjugationForm(
          mood: prev.mood,
          tense: prev.tense,
          dimensions: prev.dimensions,
          form: value,
          variants: prev.variants,
          auxiliary: prev.auxiliary,
          pronoun: prev.pronoun,
          bareForm: prev.bareForm,
          noElision: prev.noElision,
          isIrregular: prev.isIrregular,
          exceptionNote: prev.exceptionNote,
          needsReview: prev.needsReview,
        );
      } else {
        _forms.add(
          ConjugationForm(
            mood: paradigm.mood,
            tense: paradigm.tense,
            dimensions: Map<String, dynamic>.from(slot),
            auxiliary: paradigm.kind == 'compound' && _auxiliaries.isNotEmpty
                ? _auxiliaries.first
                : null,
            form: value,
          ),
        );
      }
    });
  }

  void _toggleIrregular(int idx) {
    setState(() {
      final f = _forms[idx];
      _forms[idx] = ConjugationForm(
        mood: f.mood,
        tense: f.tense,
        dimensions: f.dimensions,
        form: f.form,
        variants: f.variants,
        auxiliary: f.auxiliary,
        pronoun: f.pronoun,
        bareForm: f.bareForm,
        noElision: f.noElision,
        isIrregular: !f.isIrregular,
        exceptionNote: f.exceptionNote,
        needsReview: f.needsReview,
      );
    });
  }

  void _toggleNeedsReview(int idx) {
    setState(() {
      final f = _forms[idx];
      _forms[idx] = ConjugationForm(
        mood: f.mood,
        tense: f.tense,
        dimensions: f.dimensions,
        form: f.form,
        variants: f.variants,
        auxiliary: f.auxiliary,
        pronoun: f.pronoun,
        bareForm: f.bareForm,
        noElision: f.noElision,
        isIrregular: f.isIrregular,
        exceptionNote: f.exceptionNote,
        needsReview: !f.needsReview,
      );
      if (_forms.any((x) => x.needsReview)) {
        _isPublished = false;
      }
    });
  }

  void _updatePronounBare(int idx, {String? pronoun, String? bareForm}) {
    final f = _forms[idx];
    _forms[idx] = ConjugationForm(
      mood: f.mood,
      tense: f.tense,
      dimensions: f.dimensions,
      form: f.form,
      variants: f.variants,
      auxiliary: f.auxiliary,
      pronoun: pronoun ?? f.pronoun,
      bareForm: bareForm ?? f.bareForm,
      noElision: f.noElision,
      isIrregular: f.isIrregular,
      exceptionNote: f.exceptionNote,
      needsReview: f.needsReview,
    );
  }

  void _updateExceptionNote(int idx, String note) {
    final f = _forms[idx];
    _forms[idx] = ConjugationForm(
      mood: f.mood,
      tense: f.tense,
      dimensions: f.dimensions,
      form: f.form,
      variants: f.variants,
      auxiliary: f.auxiliary,
      pronoun: f.pronoun,
      bareForm: f.bareForm,
      noElision: f.noElision,
      isIrregular: f.isIrregular,
      exceptionNote: note.trim().isEmpty ? null : {'fr': note.trim()},
      needsReview: f.needsReview,
    );
  }

  Future<void> _save(LanguageRecord lang) async {
    final lemma = _lemmaCtrl.text.trim();
    if (lemma.isEmpty) return;

    final cleanedForms = _forms.where((f) => f.form.trim().isNotEmpty).toList();
    final repo = ref.read(referentielRepositoryProvider);
    await repo.upsertConjugation(
      ConjugationRecord(
        id: widget.initialRecord?.id ?? 0,
        langId: lang.id,
        langCode: lang.code,
        lemma: lemma,
        group: lang.grammarProfile.hasVerbGroups ? _group : null,
        auxiliaries: lang.grammarProfile.hasAuxiliaries ? _auxiliaries : const [],
        isPronominal: _isPronominal,
        reflexiveCase: _isPronominal ? _reflexiveCase : null,
        isIrregular: _isIrregular,
        isDefective: _isDefective,
        generalNote: _noteCtrl.text.trim().isEmpty ? const {} : {'fr': _noteCtrl.text.trim()},
        forms: cleanedForms,
        source: widget.initialRecord?.source ?? 'manual',
        isPublished: cleanedForms.any((f) => f.needsReview) ? false : _isPublished,
      ),
    );
    ref.invalidate(referentielConjugationsProvider);
    if (mounted) context.pop();
  }
}
