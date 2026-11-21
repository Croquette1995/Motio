import 'grammar_profile.dart';
import 'text_normalizer.dart';

enum DeclensionPos {
  noun('NOUN', 'Nom'),
  adj('ADJ', 'Adjectif'),
  det('DET', 'Déterminant');

  final String code;
  final String labelFr;

  const DeclensionPos(this.code, this.labelFr);

  static DeclensionPos? tryParse(String? raw) {
    if (raw == null) return null;
    final upper = raw.trim().toUpperCase();
    for (final p in DeclensionPos.values) {
      if (p.code == upper) return p;
    }
    return null;
  }
}

class DeclensionForm {
  final Map<String, dynamic> dimensions;
  final String? article;
  final String? bareForm;
  final String form;
  final List<String> variants;
  final bool isIrregular;
  final Map<String, String>? exceptionNote;
  final bool needsReview;

  const DeclensionForm({
    this.dimensions = const {},
    this.article,
    this.bareForm,
    required this.form,
    this.variants = const [],
    this.isIrregular = false,
    this.exceptionNote,
    this.needsReview = false,
  });

  String? get caseCode => dimensions['case'] as String?;
  String? get number => dimensions['number'] as String?;
  String? get gender => dimensions['gender'] as String?;
  String? get definiteness => dimensions['definiteness'] as String?;

  String uniquenessKey(DeclensionParadigm paradigm) {
    return paradigm.dimensions.map((d) => '$d=${dimensions[d]}').join('|');
  }

  static String buildSlotKey(
    DeclensionParadigm paradigm,
    Map<String, dynamic> slot,
  ) {
    return paradigm.dimensions.map((d) => '$d=${slot[d]}').join('|');
  }

  DeclensionForm normalized() {
    return DeclensionForm(
      dimensions: dimensions,
      article: article == null ? null : TextNormalizer.normalize(article!),
      bareForm: bareForm == null ? null : TextNormalizer.normalize(bareForm!),
      form: TextNormalizer.normalize(form),
      variants: variants.map(TextNormalizer.normalize).where((v) => v.isNotEmpty).toList(),
      isIrregular: isIrregular,
      exceptionNote: exceptionNote,
      needsReview: needsReview,
    );
  }

  static const _reservedKeys = {
    'article',
    'bare_form',
    'form',
    'variants',
    'is_irregular',
    'exception_note',
    'needs_review',
  };

  factory DeclensionForm.fromJson(Map<String, dynamic> json) {
    final dims = <String, dynamic>{};
    for (final entry in json.entries) {
      if (!_reservedKeys.contains(entry.key)) {
        dims[entry.key] = entry.value;
      }
    }
    return DeclensionForm(
      dimensions: dims,
      article: json['article'] as String?,
      bareForm: json['bare_form'] as String?,
      form: json['form'] as String,
      variants: List<String>.from(json['variants'] as List? ?? const []),
      isIrregular: (json['is_irregular'] as bool?) ?? false,
      exceptionNote: json['exception_note'] == null
          ? null
          : Map<String, String>.from(json['exception_note'] as Map),
      needsReview: (json['needs_review'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        ...dimensions,
        if (article != null) 'article': article,
        if (bareForm != null) 'bare_form': bareForm,
        'form': form,
        if (variants.isNotEmpty) 'variants': variants,
        if (isIrregular) 'is_irregular': isIrregular,
        if (exceptionNote != null && exceptionNote!.isNotEmpty) 'exception_note': exceptionNote,
        if (needsReview) 'needs_review': needsReview,
      };
}

class DeclensionRecord {
  final int id;
  final int langId;
  final String langCode;
  final String lemma;
  final DeclensionPos pos;
  final String? gender;
  final String? declensionClass;
  final bool isIrregular;
  final bool isInvariable;
  final Map<String, String> generalNote;
  final List<DeclensionForm> forms;
  final String source;
  final bool isPublished;

  const DeclensionRecord({
    this.id = 0,
    required this.langId,
    required this.langCode,
    required this.lemma,
    required this.pos,
    this.gender,
    this.declensionClass,
    this.isIrregular = false,
    this.isInvariable = false,
    this.generalNote = const {},
    this.forms = const [],
    this.source = 'manual',
    this.isPublished = false,
  });

  String get compositeKey => '$lemma#${pos.code}';
  bool get hasNeedsReview => forms.any((f) => f.needsReview);
  bool get canPublish => !hasNeedsReview;

  String noteText([String lang = 'fr']) =>
      generalNote[lang] ?? generalNote['fr'] ?? generalNote.values.firstOrNull ?? '';

  DeclensionRecord copyWith({
    int? id,
    int? langId,
    String? langCode,
    String? lemma,
    DeclensionPos? pos,
    String? gender,
    bool clearGender = false,
    String? declensionClass,
    bool clearDeclensionClass = false,
    bool? isIrregular,
    bool? isInvariable,
    Map<String, String>? generalNote,
    List<DeclensionForm>? forms,
    String? source,
    bool? isPublished,
  }) {
    return DeclensionRecord(
      id: id ?? this.id,
      langId: langId ?? this.langId,
      langCode: langCode ?? this.langCode,
      lemma: lemma ?? this.lemma,
      pos: pos ?? this.pos,
      gender: clearGender ? null : (gender ?? this.gender),
      declensionClass: clearDeclensionClass ? null : (declensionClass ?? this.declensionClass),
      isIrregular: isIrregular ?? this.isIrregular,
      isInvariable: isInvariable ?? this.isInvariable,
      generalNote: generalNote ?? this.generalNote,
      forms: forms ?? this.forms,
      source: source ?? this.source,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  Map<String, dynamic> toBundleJson() => {
        'lang': langCode,
        'lemma': lemma,
        'pos': pos.code,
        'gender': gender,
        'declension_class': declensionClass,
        'is_irregular': isIrregular,
        'is_invariable': isInvariable,
        'general_note': generalNote,
        'source': source,
        'is_published': isPublished,
        'forms': forms.map((f) => f.toJson()).toList(),
      };
}
