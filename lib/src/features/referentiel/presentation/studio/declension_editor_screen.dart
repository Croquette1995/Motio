import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/database/database_providers.dart';
import '../../../../core/theme/bauhaus_theme.dart';
import '../../application/referentiel_controllers.dart';
import '../../domain/declension.dart';
import '../../domain/grammar_profile.dart';

class DeclensionEditorScreen extends ConsumerStatefulWidget {
  final DeclensionRecord? initialRecord;

  const DeclensionEditorScreen({super.key, this.initialRecord});

  @override
  ConsumerState<DeclensionEditorScreen> createState() => _DeclensionEditorScreenState();
}

class _DeclensionEditorScreenState extends ConsumerState<DeclensionEditorScreen> {
  late TextEditingController _lemmaCtrl;
  late TextEditingController _noteCtrl;
  late DeclensionPos _pos;
  String? _gender;
  String? _declensionClass;
  bool _isIrregular = false;
  bool _isInvariable = false;
  bool _isPublished = false;
  late List<DeclensionForm> _forms;
  String _selectedDefMode = 'DEF';

  @override
  void initState() {
    super.initState();
    final r = widget.initialRecord;
    _lemmaCtrl = TextEditingController(text: r?.lemma ?? '');
    _noteCtrl = TextEditingController(text: r?.noteText() ?? '');
    _pos = r?.pos ?? DeclensionPos.noun;
    _gender = r?.gender;
    _declensionClass = r?.declensionClass;
    _isIrregular = r?.isIrregular ?? false;
    _isInvariable = r?.isInvariable ?? false;
    _isPublished = r?.isPublished ?? false;
    _forms = List<DeclensionForm>.from(r?.forms ?? const []);
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
        appBar: AppBar(title: const Text('ÉDITEUR DÉCLINAISON')),
        body: Center(child: CircularProgressIndicator(color: b.slate)),
      ),
      error: (e, _) => Scaffold(body: Center(child: Text('Erreur : $e'))),
      data: (lang) {
        if (lang == null || !lang.grammarProfile.hasDeclensions) {
          return Scaffold(
            appBar: AppBar(title: const Text('DÉCLINAISON')),
            body: const Center(child: Text('Les déclinaisons ne sont pas activées pour cette langue.')),
          );
        }

        final profile = lang.grammarProfile;
        final availablePos = profile.declensionParadigms
            .map((p) => DeclensionPos.tryParse(p.pos))
            .whereType<DeclensionPos>()
            .toList();
        if (availablePos.isNotEmpty && !availablePos.contains(_pos)) {
          _pos = availablePos.first;
        }
        final paradigm = profile.findDeclensionParadigm(_pos.code);
        final slots = paradigm?.expectedSlots(profile) ?? const <Map<String, dynamic>>[];
        final hasDefiniteness = paradigm?.dimensions.contains('definiteness') ?? false;
        final visibleSlots = (_pos == DeclensionPos.adj && hasDefiniteness)
            ? slots.where((s) => s['definiteness'] == _selectedDefMode).toList()
            : slots;
        final hasNeedsReview = _forms.any((f) => f.needsReview);
        final filledCount = _forms.where((f) => f.form.trim().isNotEmpty).length;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              widget.initialRecord == null ? 'NOUVELLE DÉCLINAISON' : 'ÉDITER ${widget.initialRecord!.lemma}',
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
                      decoration: const InputDecoration(labelText: 'Lemme'),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<DeclensionPos>(
                      initialValue: _pos,
                      decoration: const InputDecoration(labelText: 'Partie du discours (POS)'),
                      items: availablePos
                          .map((p) => DropdownMenuItem(value: p, child: Text('${p.code} — ${p.labelFr}')))
                          .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          _pos = v;
                          if (_pos != DeclensionPos.noun) {
                            _gender = null;
                            _declensionClass = null;
                          }
                        });
                      },
                    ),
                    if (_pos == DeclensionPos.noun) ...[
                      if (profile.genders.isNotEmpty) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: profile.genders.contains(_gender) ? _gender : null,
                          decoration: const InputDecoration(labelText: 'Genre intrinsèque'),
                          items: profile.genders
                              .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                              .toList(),
                          onChanged: (v) => setState(() => _gender = v),
                        ),
                      ],
                      if (profile.hasDeclensionClasses) ...[
                        const SizedBox(height: 12),
                        DropdownButtonFormField<String>(
                          initialValue: profile.declensionClasses.contains(_declensionClass)
                              ? _declensionClass
                              : null,
                          decoration: const InputDecoration(labelText: 'Classe de déclinaison (NOUN)'),
                          items: profile.declensionClasses
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => _declensionClass = v),
                        ),
                      ],
                    ],
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mot irrégulier'),
                      value: _isIrregular,
                      onChanged: (v) => setState(() => _isIrregular = v),
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Mot invariable'),
                      value: _isInvariable,
                      onChanged: (v) => setState(() => _isInvariable = v),
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
                  const Text('GRILLE DES FORMES', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                  const Spacer(),
                  Chip(label: Text('$filledCount / ${slots.length}')),
                ],
              ),
              if (_pos == DeclensionPos.adj && hasDefiniteness) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    for (final m in const ['DEF', 'INDEF', 'ZERO'])
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: ChoiceChip(
                            label: Text(m),
                            selected: _selectedDefMode == m,
                            selectedColor: b.pastelYellow,
                            onSelected: (_) => setState(() => _selectedDefMode = m),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              const SizedBox(height: 8),
              if (paradigm != null)
                Container(
                  decoration: BoxDecoration(
                    color: b.cardSurface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: b.slate, width: 1.5),
                  ),
                  child: Column(
                    children: visibleSlots.map((slot) {
                      final key = DeclensionForm.buildSlotKey(paradigm, slot);
                      final idx = _forms.indexWhere((f) => f.uniquenessKey(paradigm) == key);
                      final existing = idx >= 0 ? _forms[idx] : null;
                      final slotLabel = slot.entries
                          .where((e) => e.key != 'definiteness')
                          .map((e) => e.value.toString())
                          .join(' · ');

                      return Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (existing?.needsReview ?? false)
                              ? b.pastelRed.withValues(alpha: 0.2)
                              : null,
                          border: Border(bottom: BorderSide(color: b.lineGrey)),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 110,
                                  child: Text(
                                    slotLabel,
                                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                                  ),
                                ),
                                Expanded(
                                  child: TextFormField(
                                    key: ValueKey('decl_form_$key'),
                                    initialValue: existing?.form ?? '',
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      hintText: 'Forme complète...',
                                    ),
                                    onChanged: (val) => _upsertSlot(paradigm, slot, form: val),
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
                                      : () => _toggleFlag(idx, irregular: true),
                                ),
                                IconButton(
                                  tooltip: 'À relire',
                                  icon: Icon(
                                    Icons.flag,
                                    color: (existing?.needsReview ?? false) ? b.pastelRed : b.lineGrey,
                                  ),
                                  onPressed: existing == null
                                      ? null
                                      : () => _toggleFlag(idx, review: true),
                                ),
                              ],
                            ),
                            if (_pos == DeclensionPos.noun && existing != null) ...[
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      key: ValueKey('decl_art_$key'),
                                      initialValue: existing.article ?? '',
                                      decoration: const InputDecoration(isDense: true, labelText: 'Article'),
                                      onChanged: (val) => _upsertSlot(paradigm, slot, article: val),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: TextFormField(
                                      key: ValueKey('decl_bare_$key'),
                                      initialValue: existing.bareForm ?? '',
                                      decoration: const InputDecoration(isDense: true, labelText: 'Mot nu'),
                                      onChanged: (val) => _upsertSlot(paradigm, slot, bareForm: val),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                            if (existing != null && existing.isIrregular) ...[
                              const SizedBox(height: 6),
                              TextFormField(
                                key: ValueKey('decl_note_$key'),
                                initialValue: existing.exceptionNote?['fr'] ?? '',
                                decoration: const InputDecoration(
                                  isDense: true,
                                  labelText: "Note d'exception (FR)",
                                ),
                                onChanged: (val) => _upsertSlot(paradigm, slot, note: val),
                              ),
                            ],
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

  void _upsertSlot(
    DeclensionParadigm paradigm,
    Map<String, dynamic> slot, {
    String? form,
    String? article,
    String? bareForm,
    String? note,
  }) {
    final key = DeclensionForm.buildSlotKey(paradigm, slot);
    final idx = _forms.indexWhere((f) => f.uniquenessKey(paradigm) == key);
    setState(() {
      if (idx >= 0) {
        final prev = _forms[idx];
        _forms[idx] = DeclensionForm(
          dimensions: prev.dimensions,
          article: article ?? prev.article,
          bareForm: bareForm ?? prev.bareForm,
          form: form ?? prev.form,
          variants: prev.variants,
          isIrregular: prev.isIrregular,
          exceptionNote: note != null
              ? (note.trim().isEmpty ? null : {'fr': note.trim()})
              : prev.exceptionNote,
          needsReview: prev.needsReview,
        );
      } else {
        _forms.add(
          DeclensionForm(
            dimensions: Map<String, dynamic>.from(slot),
            article: article,
            bareForm: bareForm,
            form: form ?? '',
          ),
        );
      }
    });
  }

  void _toggleFlag(int idx, {bool irregular = false, bool review = false}) {
    setState(() {
      final f = _forms[idx];
      _forms[idx] = DeclensionForm(
        dimensions: f.dimensions,
        article: f.article,
        bareForm: f.bareForm,
        form: f.form,
        variants: f.variants,
        isIrregular: irregular ? !f.isIrregular : f.isIrregular,
        exceptionNote: f.exceptionNote,
        needsReview: review ? !f.needsReview : f.needsReview,
      );
      if (_forms.any((x) => x.needsReview)) {
        _isPublished = false;
      }
    });
  }

  Future<void> _save(LanguageRecord lang) async {
    final lemma = _lemmaCtrl.text.trim();
    if (lemma.isEmpty) return;

    final cleaned = _forms.where((f) => f.form.trim().isNotEmpty).toList();
    final repo = ref.read(referentielRepositoryProvider);
    await repo.upsertDeclension(
      DeclensionRecord(
        id: widget.initialRecord?.id ?? 0,
        langId: lang.id,
        langCode: lang.code,
        lemma: lemma,
        pos: _pos,
        gender: _pos == DeclensionPos.noun ? _gender : null,
        declensionClass: _pos == DeclensionPos.noun ? _declensionClass : null,
        isIrregular: _isIrregular,
        isInvariable: _isInvariable,
        generalNote: _noteCtrl.text.trim().isEmpty ? const {} : {'fr': _noteCtrl.text.trim()},
        forms: cleaned,
        source: widget.initialRecord?.source ?? 'manual',
        isPublished: cleaned.any((f) => f.needsReview) ? false : _isPublished,
      ),
    );
    ref.invalidate(referentielDeclensionsProvider);
    if (mounted) context.pop();
  }
}
