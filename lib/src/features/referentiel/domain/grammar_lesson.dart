import 'text_normalizer.dart';

enum LessonBlockType {
  rule('rule', 'Règle'),
  exception('exception', 'Exception'),
  tip('tip', 'Astuce'),
  table('table', 'Tableau');

  final String code;
  final String labelFr;
  const LessonBlockType(this.code, this.labelFr);

  static LessonBlockType fromCode(String raw) {
    return LessonBlockType.values.firstWhere(
      (e) => e.code == raw,
      orElse: () => LessonBlockType.rule,
    );
  }
}

class LessonExample {
  final String sentence;
  final String? highlight;

  const LessonExample({
    required this.sentence,
    this.highlight,
  });

  factory LessonExample.fromJson(Map<String, dynamic> json) {
    return LessonExample(
      sentence: TextNormalizer.normalize(json['sentence'] as String? ?? ''),
      highlight: json['highlight'] == null
          ? null
          : TextNormalizer.normalize(json['highlight'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'sentence': sentence,
        if (highlight != null && highlight!.isNotEmpty) 'highlight': highlight,
      };
}

class LessonBlock {
  final String id;
  final LessonBlockType type;
  final Map<String, String> title;
  final Map<String, String> content;
  final List<LessonExample> examples;
  final List<String> headers;
  final List<List<String>> rows;

  const LessonBlock({
    required this.id,
    required this.type,
    this.title = const {},
    this.content = const {},
    this.examples = const [],
    this.headers = const [],
    this.rows = const [],
  });

  String titleText([String lang = 'fr']) =>
      title[lang] ?? title['fr'] ?? title.values.firstOrNull ?? '';

  String contentText([String lang = 'fr']) =>
      content[lang] ?? content['fr'] ?? content.values.firstOrNull ?? '';

  factory LessonBlock.fromJson(Map<String, dynamic> json) {
    return LessonBlock(
      id: json['id'] as String,
      type: LessonBlockType.fromCode(json['type'] as String? ?? 'rule'),
      title: Map<String, String>.from(json['title'] as Map? ?? const {}),
      content: Map<String, String>.from(json['content'] as Map? ?? const {}),
      examples: (json['examples'] as List? ?? const [])
          .map((e) => LessonExample.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      headers: List<String>.from(json['headers'] as List? ?? const []),
      rows: (json['rows'] as List? ?? const [])
          .map((r) => List<String>.from(r as List))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.code,
        'title': title,
        if (type != LessonBlockType.table) 'content': content,
        if (examples.isNotEmpty) 'examples': examples.map((e) => e.toJson()).toList(),
        if (type == LessonBlockType.table) 'headers': headers,
        if (type == LessonBlockType.table) 'rows': rows,
      };
}

enum LessonExerciseType {
  cloze('cloze', 'Texte à trou'),
  qcm('qcm', 'QCM'),
  transformation('transformation', 'Transformation');

  final String code;
  final String labelFr;
  const LessonExerciseType(this.code, this.labelFr);

  static LessonExerciseType fromCode(String raw) {
    return LessonExerciseType.values.firstWhere(
      (e) => e.code == raw,
      orElse: () => LessonExerciseType.cloze,
    );
  }
}

class LessonExercise {
  final String id;
  final LessonExerciseType type;
  final Map<String, String> prompt;
  final String sentenceBefore;
  final String sentenceAfter;
  final String answer;
  final List<String> acceptedAnswers;
  final List<String> distractors;
  final Map<String, String> explanation;

  const LessonExercise({
    required this.id,
    required this.type,
    this.prompt = const {},
    this.sentenceBefore = '',
    this.sentenceAfter = '',
    required this.answer,
    this.acceptedAnswers = const [],
    this.distractors = const [],
    this.explanation = const {},
  });

  String promptText([String lang = 'fr']) =>
      prompt[lang] ?? prompt['fr'] ?? prompt.values.firstOrNull ?? '';

  String explanationText([String lang = 'fr']) =>
      explanation[lang] ?? explanation['fr'] ?? explanation.values.firstOrNull ?? '';

  LessonExercise normalized() {
    return LessonExercise(
      id: id.trim(),
      type: type,
      prompt: prompt,
      sentenceBefore: TextNormalizer.normalizePreservingEdges(sentenceBefore),
      sentenceAfter: TextNormalizer.normalizePreservingEdges(sentenceAfter),
      answer: TextNormalizer.normalize(answer),
      acceptedAnswers: acceptedAnswers.map(TextNormalizer.normalize).where((e) => e.isNotEmpty).toList(),
      distractors: distractors.map(TextNormalizer.normalize).where((e) => e.isNotEmpty).toList(),
      explanation: explanation,
    );
  }

  factory LessonExercise.fromJson(Map<String, dynamic> json) {
    return LessonExercise(
      id: json['id'] as String,
      type: LessonExerciseType.fromCode(json['type'] as String? ?? 'cloze'),
      prompt: Map<String, String>.from(json['prompt'] as Map? ?? const {}),
      sentenceBefore: (json['sentence_before'] as String?) ?? '',
      sentenceAfter: (json['sentence_after'] as String?) ?? '',
      answer: json['answer'] as String,
      acceptedAnswers: List<String>.from(json['accepted_answers'] as List? ?? const []),
      distractors: List<String>.from(json['distractors'] as List? ?? const []),
      explanation: Map<String, String>.from(json['explanation'] as Map? ?? const {}),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.code,
        'prompt': prompt,
        'sentence_before': sentenceBefore,
        'sentence_after': sentenceAfter,
        'answer': answer,
        if (acceptedAnswers.isNotEmpty) 'accepted_answers': acceptedAnswers,
        if (distractors.isNotEmpty) 'distractors': distractors,
        'explanation': explanation,
      };
}

class TargetTense {
  final String mood;
  final String tense;

  const TargetTense({required this.mood, required this.tense});

  factory TargetTense.fromJson(Map<String, dynamic> json) => TargetTense(
        mood: json['mood'] as String,
        tense: json['tense'] as String,
      );

  Map<String, dynamic> toJson() => {'mood': mood, 'tense': tense};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TargetTense && mood == other.mood && tense == other.tense;

  @override
  int get hashCode => mood.hashCode ^ tense.hashCode;
}

class GrammarLessonRecord {
  final int id;
  final int langId;
  final String langCode;
  final String slug;
  final String level;
  final int order;
  final Map<String, String> title;
  final List<int> prerequisiteIds;
  final List<int> linkedVerbIds;
  final List<TargetTense> targetTenses;
  final List<int> linkedDeclensionIds;
  final List<String> targetCases;
  final List<LessonBlock> blocks;
  final List<LessonExercise> exercises;
  final bool isPublished;

  const GrammarLessonRecord({
    this.id = 0,
    required this.langId,
    required this.langCode,
    required this.slug,
    required this.level,
    required this.order,
    required this.title,
    this.prerequisiteIds = const [],
    this.linkedVerbIds = const [],
    this.targetTenses = const [],
    this.linkedDeclensionIds = const [],
    this.targetCases = const [],
    this.blocks = const [],
    this.exercises = const [],
    this.isPublished = false,
  });

  String titleText([String lang = 'fr']) =>
      title[lang] ?? title['fr'] ?? title.values.firstOrNull ?? slug;

  GrammarLessonRecord copyWith({
    int? id,
    int? langId,
    String? langCode,
    String? slug,
    String? level,
    int? order,
    Map<String, String>? title,
    List<int>? prerequisiteIds,
    List<int>? linkedVerbIds,
    List<TargetTense>? targetTenses,
    List<int>? linkedDeclensionIds,
    List<String>? targetCases,
    List<LessonBlock>? blocks,
    List<LessonExercise>? exercises,
    bool? isPublished,
  }) {
    return GrammarLessonRecord(
      id: id ?? this.id,
      langId: langId ?? this.langId,
      langCode: langCode ?? this.langCode,
      slug: slug ?? this.slug,
      level: level ?? this.level,
      order: order ?? this.order,
      title: title ?? this.title,
      prerequisiteIds: prerequisiteIds ?? this.prerequisiteIds,
      linkedVerbIds: linkedVerbIds ?? this.linkedVerbIds,
      targetTenses: targetTenses ?? this.targetTenses,
      linkedDeclensionIds: linkedDeclensionIds ?? this.linkedDeclensionIds,
      targetCases: targetCases ?? this.targetCases,
      blocks: blocks ?? this.blocks,
      exercises: exercises ?? this.exercises,
      isPublished: isPublished ?? this.isPublished,
    );
  }
}

class ExerciseResult {
  final double score;
  final int attempts;
  final DateTime lastAt;

  const ExerciseResult({
    required this.score,
    required this.attempts,
    required this.lastAt,
  });

  factory ExerciseResult.fromJson(Map<String, dynamic> json) {
    return ExerciseResult(
      score: (json['score'] as num).toDouble(),
      attempts: (json['attempts'] as num).toInt(),
      lastAt: DateTime.parse(json['last_at'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'score': score,
        'attempts': attempts,
        'last_at': lastAt.toIso8601String(),
      };
}

class LessonProgressRecord {
  final int id;
  final String userKey;
  final int lessonId;
  final Map<String, ExerciseResult> exerciseResults;
  final double score;
  final DateTime lastSeenAt;
  final DateTime? nextDueAt;

  const LessonProgressRecord({
    this.id = 0,
    this.userKey = 'local',
    required this.lessonId,
    this.exerciseResults = const {},
    this.score = 0.0,
    required this.lastSeenAt,
    this.nextDueAt,
  });
}
