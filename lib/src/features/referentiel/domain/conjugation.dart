import 'grammar_profile.dart';
import 'text_normalizer.dart';

class ConjugationForm {
  final String mood;
  final String tense;
  final Map<String, dynamic> dimensions;
  final String form;
  final List<String> variants;
  final String? auxiliary;
  final String? pronoun;
  final String? bareForm;
  final bool noElision;
  final bool isIrregular;
  final Map<String, String>? exceptionNote;
  final bool needsReview;

  const ConjugationForm({
    required this.mood,
    required this.tense,
    this.dimensions = const {},
    required this.form,
    this.variants = const [],
    this.auxiliary,
    this.pronoun,
    this.bareForm,
    this.noElision = false,
    this.isIrregular = false,
    this.exceptionNote,
    this.needsReview = false,
  });

  dynamic get person => dimensions['person'];
  String? get number => dimensions['number'] as String?;
  String? get gender => dimensions['gender'] as String?;

  String uniquenessKey(VerbParadigm paradigm, int auxiliariesCount) {
    final parts = <String>[
      'mood=$mood',
      'tense=$tense',
      for (final d in paradigm.dimensions) '$d=${dimensions[d]}',
      if (auxiliariesCount > 1) 'auxiliary=${auxiliary ?? ''}',
    ];
    return parts.join('|');
  }

  String slotKey(VerbParadigm paradigm) {
    final parts = <String>[
      'mood=$mood',
      'tense=$tense',
      for (final d in paradigm.dimensions) '$d=${dimensions[d]}',
    ];
    return parts.join('|');
  }

  static String buildSlotKey(
    String mood,
    String tense,
    VerbParadigm paradigm,
    Map<String, dynamic> slot,
  ) {
    final parts = <String>[
      'mood=$mood',
      'tense=$tense',
      for (final d in paradigm.dimensions) '$d=${slot[d]}',
    ];
    return parts.join('|');
  }

  ConjugationForm normalized() {
    return ConjugationForm(
      mood: mood.trim(),
      tense: tense.trim(),
      dimensions: dimensions,
      form: TextNormalizer.normalize(form),
      variants: variants.map(TextNormalizer.normalize).where((v) => v.isNotEmpty).toList(),
      auxiliary: auxiliary == null ? null : TextNormalizer.normalize(auxiliary!),
      pronoun: pronoun == null ? null : TextNormalizer.normalize(pronoun!),
      bareForm: bareForm == null ? null : TextNormalizer.normalize(bareForm!),
      noElision: noElision,
      isIrregular: isIrregular,
      exceptionNote: exceptionNote,
      needsReview: needsReview,
    );
  }

  static const _reservedKeys = {
    'mood',
    'tense',
    'form',
    'variants',
    'auxiliary',
    'pronoun',
    'bare_form',
    'no_elision',
    'is_irregular',
    'exception_note',
    'needs_review',
  };

  factory ConjugationForm.fromJson(Map<String, dynamic> json) {
    final dims = <String, dynamic>{};
    for (final entry in json.entries) {
      if (!_reservedKeys.contains(entry.key)) {
        dims[entry.key] = entry.value;
      }
    }
    return ConjugationForm(
      mood: json['mood'] as String,
      tense: json['tense'] as String,
      dimensions: dims,
      form: json['form'] as String,
      variants: List<String>.from(json['variants'] as List? ?? const []),
      auxiliary: json['auxiliary'] as String?,
      pronoun: json['pronoun'] as String?,
      bareForm: json['bare_form'] as String?,
      noElision: (json['no_elision'] as bool?) ?? false,
      isIrregular: (json['is_irregular'] as bool?) ?? false,
      exceptionNote: json['exception_note'] == null
          ? null
          : Map<String, String>.from(json['exception_note'] as Map),
      needsReview: (json['needs_review'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'mood': mood,
        'tense': tense,
        ...dimensions,
        if (auxiliary != null) 'auxiliary': auxiliary,
        if (pronoun != null) 'pronoun': pronoun,
        if (bareForm != null) 'bare_form': bareForm,
        'form': form,
        if (variants.isNotEmpty) 'variants': variants,
        if (noElision) 'no_elision': noElision,
        if (isIrregular) 'is_irregular': isIrregular,
        if (exceptionNote != null && exceptionNote!.isNotEmpty) 'exception_note': exceptionNote,
        if (needsReview) 'needs_review': needsReview,
      };
}

class ConjugationRecord {
  final int id;
  final int langId;
  final String langCode;
  final String lemma;
  final String? group;
  final List<String> auxiliaries;
  final bool isPronominal;
  final String? reflexiveCase;
  final bool isIrregular;
  final bool isDefective;
  final Map<String, String> generalNote;
  final List<ConjugationForm> forms;
  final String source; // 'manual' | 'ai' | 'external'
  final bool isPublished;

  const ConjugationRecord({
    this.id = 0,
    required this.langId,
    required this.langCode,
    required this.lemma,
    this.group,
    this.auxiliaries = const [],
    this.isPronominal = false,
    this.reflexiveCase,
    this.isIrregular = false,
    this.isDefective = false,
    this.generalNote = const {},
    this.forms = const [],
    this.source = 'manual',
    this.isPublished = false,
  });

  bool get hasNeedsReview => forms.any((f) => f.needsReview);
  bool get canPublish => !hasNeedsReview;

  String noteText([String lang = 'fr']) =>
      generalNote[lang] ?? generalNote['fr'] ?? generalNote.values.firstOrNull ?? '';

  ConjugationRecord copyWith({
    int? id,
    int? langId,
    String? langCode,
    String? lemma,
    String? group,
    bool clearGroup = false,
    List<String>? auxiliaries,
    bool? isPronominal,
    String? reflexiveCase,
    bool clearReflexiveCase = false,
    bool? isIrregular,
    bool? isDefective,
    Map<String, String>? generalNote,
    List<ConjugationForm>? forms,
    String? source,
    bool? isPublished,
  }) {
    return ConjugationRecord(
      id: id ?? this.id,
      langId: langId ?? this.langId,
      langCode: langCode ?? this.langCode,
      lemma: lemma ?? this.lemma,
      group: clearGroup ? null : (group ?? this.group),
      auxiliaries: auxiliaries ?? this.auxiliaries,
      isPronominal: isPronominal ?? this.isPronominal,
      reflexiveCase: clearReflexiveCase ? null : (reflexiveCase ?? this.reflexiveCase),
      isIrregular: isIrregular ?? this.isIrregular,
      isDefective: isDefective ?? this.isDefective,
      generalNote: generalNote ?? this.generalNote,
      forms: forms ?? this.forms,
      source: source ?? this.source,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  Map<String, dynamic> toBundleJson() => {
        'lang': langCode,
        'lemma': lemma,
        'group': group,
        'auxiliaries': auxiliaries,
        'is_pronominal': isPronominal,
        'reflexive_case': reflexiveCase,
        'is_irregular': isIrregular,
        'is_defective': isDefective,
        'general_note': generalNote,
        'source': source,
        'is_published': isPublished,
        'forms': forms.map((f) => f.toJson()).toList(),
      };
}
