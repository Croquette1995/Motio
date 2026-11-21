class SubjectPronounSpec {
  final String form;
  final String? elided;

  const SubjectPronounSpec({
    required this.form,
    this.elided,
  });

  factory SubjectPronounSpec.fromJson(Map<String, dynamic> json) {
    return SubjectPronounSpec(
      form: json['form'] as String,
      elided: json['elided'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'form': form,
        if (elided != null) 'elided': elided,
      };
}

class VerbParadigm {
  final String mood;
  final String tense;
  final String kind; // 'simple' | 'compound'
  final List<String> dimensions;
  final List<Map<String, dynamic>>? slots;
  final Map<String, String> labelL10n;

  const VerbParadigm({
    required this.mood,
    required this.tense,
    required this.kind,
    required this.dimensions,
    this.slots,
    this.labelL10n = const {},
  });

  String label([String lang = 'fr']) =>
      labelL10n[lang] ?? labelL10n['fr'] ?? labelL10n.values.firstOrNull ?? '$mood $tense';

  List<Map<String, dynamic>> expectedSlots(GrammarProfile profile) {
    if (slots != null && slots!.isNotEmpty) {
      return slots!;
    }
    if (dimensions.isEmpty) {
      return [const <String, dynamic>{}];
    }
    return _cartesianSlots(dimensions, profile);
  }

  factory VerbParadigm.fromJson(Map<String, dynamic> json) {
    return VerbParadigm(
      mood: json['mood'] as String,
      tense: json['tense'] as String,
      kind: (json['kind'] as String?) ?? 'simple',
      dimensions: List<String>.from(json['dimensions'] as List? ?? const []),
      slots: (json['slots'] as List?)
          ?.map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      labelL10n: Map<String, String>.from(json['label_l10n'] as Map? ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'mood': mood,
        'tense': tense,
        'kind': kind,
        'dimensions': dimensions,
        if (slots != null) 'slots': slots,
        'label_l10n': labelL10n,
      };
}

class DeclensionParadigm {
  final String pos; // 'NOUN' | 'ADJ' | 'DET'
  final List<String> dimensions;
  final List<Map<String, dynamic>>? slots;
  final Map<String, String> labelL10n;

  const DeclensionParadigm({
    required this.pos,
    required this.dimensions,
    this.slots,
    this.labelL10n = const {},
  });

  String label([String lang = 'fr']) =>
      labelL10n[lang] ?? labelL10n['fr'] ?? labelL10n.values.firstOrNull ?? pos;

  List<Map<String, dynamic>> expectedSlots(GrammarProfile profile) {
    if (slots != null && slots!.isNotEmpty) {
      return slots!;
    }
    if (dimensions.isEmpty) {
      return [const <String, dynamic>{}];
    }
    return _cartesianSlots(dimensions, profile);
  }

  factory DeclensionParadigm.fromJson(Map<String, dynamic> json) {
    return DeclensionParadigm(
      pos: json['pos'] as String,
      dimensions: List<String>.from(json['dimensions'] as List? ?? const []),
      slots: (json['slots'] as List?)
          ?.map((e) => Map<String, dynamic>.from(e as Map))
          .toList(),
      labelL10n: Map<String, String>.from(json['label_l10n'] as Map? ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'pos': pos,
        'dimensions': dimensions,
        if (slots != null) 'slots': slots,
        'label_l10n': labelL10n,
      };
}

List<Map<String, dynamic>> _cartesianSlots(
  List<String> dimensions,
  GrammarProfile profile,
) {
  List<Map<String, dynamic>> current = [{}];
  for (final dim in dimensions) {
    final values = profile.valuesForDimension(dim);
    if (values.isEmpty) continue;
    final next = <Map<String, dynamic>>[];
    for (final existing in current) {
      for (final val in values) {
        next.add({...existing, dim: val});
      }
    }
    current = next;
  }
  return current;
}

class GrammarProfile {
  final bool hasVerbGroups;
  final List<String> verbGroups;
  final bool hasAuxiliaries;
  final List<String> auxiliaries;
  final bool hasPronominalVerbs;
  final List<String> reflexiveCases;
  final Map<String, SubjectPronounSpec>? subjectPronouns;
  final String? elisionPattern;
  final List<String> genders;
  final bool hasDeclensions;
  final List<String> cases;
  final Map<String, Map<String, String>> caseLabelsL10n;
  final bool hasDeclensionClasses;
  final List<String> declensionClasses;
  final List<DeclensionParadigm> declensionParadigms;
  final List<VerbParadigm> paradigms;
  final Map<String, List<dynamic>> dimensionValues;

  const GrammarProfile({
    this.hasVerbGroups = false,
    this.verbGroups = const [],
    this.hasAuxiliaries = false,
    this.auxiliaries = const [],
    this.hasPronominalVerbs = false,
    this.reflexiveCases = const [],
    this.subjectPronouns,
    this.elisionPattern,
    this.genders = const [],
    this.hasDeclensions = false,
    this.cases = const [],
    this.caseLabelsL10n = const {},
    this.hasDeclensionClasses = false,
    this.declensionClasses = const [],
    this.declensionParadigms = const [],
    this.paradigms = const [],
    this.dimensionValues = const {},
  });

  List<dynamic> valuesForDimension(String dim) {
    if (dimensionValues.containsKey(dim)) {
      return dimensionValues[dim]!;
    }
    return switch (dim) {
      'person' => const [1, 2, 3],
      'number' => const ['SG', 'PL'],
      'gender' => genders.isNotEmpty ? genders : const ['MASC', 'FEM'],
      'case' => cases,
      'definiteness' => const ['DEF', 'INDEF', 'ZERO'],
      _ => const [],
    };
  }

  VerbParadigm? findVerbParadigm(String mood, String tense) {
    for (final p in paradigms) {
      if (p.mood == mood && p.tense == tense) return p;
    }
    return null;
  }

  DeclensionParadigm? findDeclensionParadigm(String pos) {
    for (final p in declensionParadigms) {
      if (p.pos == pos) return p;
    }
    return null;
  }

  String caseLabel(String caseCode, [String lang = 'fr']) {
    final map = caseLabelsL10n[caseCode];
    if (map == null) return caseCode;
    return map[lang] ?? map['fr'] ?? caseCode;
  }

  factory GrammarProfile.fromJson(Map<String, dynamic> json) {
    final rawPronouns = json['subject_pronouns'] as Map?;
    final pronouns = rawPronouns?.map(
      (k, v) => MapEntry(
        k.toString(),
        SubjectPronounSpec.fromJson(Map<String, dynamic>.from(v as Map)),
      ),
    );
    final rawCaseLabels = json['case_labels_l10n'] as Map? ?? const {};
    final caseLabels = rawCaseLabels.map(
      (k, v) => MapEntry(
        k.toString(),
        Map<String, String>.from(v as Map),
      ),
    );
    final rawDimValues = json['dimension_values'] as Map? ?? const {};
    final dimValues = rawDimValues.map(
      (k, v) => MapEntry(k.toString(), List<dynamic>.from(v as List)),
    );

    return GrammarProfile(
      hasVerbGroups: (json['has_verb_groups'] as bool?) ?? false,
      verbGroups: List<String>.from(json['verb_groups'] as List? ?? const []),
      hasAuxiliaries: (json['has_auxiliaries'] as bool?) ?? false,
      auxiliaries: List<String>.from(json['auxiliaries'] as List? ?? const []),
      hasPronominalVerbs: (json['has_pronominal_verbs'] as bool?) ?? false,
      reflexiveCases: List<String>.from(json['reflexive_cases'] as List? ?? const []),
      subjectPronouns: pronouns,
      elisionPattern: json['elision_pattern'] as String?,
      genders: List<String>.from(json['genders'] as List? ?? const []),
      hasDeclensions: (json['has_declensions'] as bool?) ?? false,
      cases: List<String>.from(json['cases'] as List? ?? const []),
      caseLabelsL10n: caseLabels,
      hasDeclensionClasses: (json['has_declension_classes'] as bool?) ?? false,
      declensionClasses: List<String>.from(json['declension_classes'] as List? ?? const []),
      declensionParadigms: (json['declension_paradigms'] as List? ?? const [])
          .map((e) => DeclensionParadigm.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      paradigms: (json['paradigms'] as List? ?? const [])
          .map((e) => VerbParadigm.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      dimensionValues: dimValues,
    );
  }

  Map<String, dynamic> toJson() => {
        'has_verb_groups': hasVerbGroups,
        'verb_groups': verbGroups,
        'has_auxiliaries': hasAuxiliaries,
        'auxiliaries': auxiliaries,
        'has_pronominal_verbs': hasPronominalVerbs,
        'reflexive_cases': reflexiveCases,
        'subject_pronouns': subjectPronouns?.map((k, v) => MapEntry(k, v.toJson())),
        if (elisionPattern != null) 'elision_pattern': elisionPattern,
        'genders': genders,
        'has_declensions': hasDeclensions,
        'cases': cases,
        'case_labels_l10n': caseLabelsL10n,
        'has_declension_classes': hasDeclensionClasses,
        'declension_classes': declensionClasses,
        'declension_paradigms': declensionParadigms.map((e) => e.toJson()).toList(),
        'paradigms': paradigms.map((e) => e.toJson()).toList(),
        if (dimensionValues.isNotEmpty) 'dimension_values': dimensionValues,
      };
}

class LanguageRecord {
  final int id;
  final String code;
  final Map<String, String> nameL10n;
  final bool isNonLatin;
  final GrammarProfile grammarProfile;

  const LanguageRecord({
    required this.id,
    required this.code,
    required this.nameL10n,
    this.isNonLatin = false,
    required this.grammarProfile,
  });

  String displayName([String locale = 'fr']) =>
      nameL10n[locale] ?? nameL10n['fr'] ?? code.toUpperCase();
}
