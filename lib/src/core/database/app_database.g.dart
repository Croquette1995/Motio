// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WordsTableTable extends WordsTable
    with TableInfo<$WordsTableTable, WordEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _termMeta = const VerificationMeta('term');
  @override
  late final GeneratedColumn<String> term = GeneratedColumn<String>(
    'term',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _translationMeta = const VerificationMeta(
    'translation',
  );
  @override
  late final GeneratedColumn<String> translation = GeneratedColumn<String>(
    'translation',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contextSentenceMeta = const VerificationMeta(
    'contextSentence',
  );
  @override
  late final GeneratedColumn<String> contextSentence = GeneratedColumn<String>(
    'context_sentence',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _targetLanguageMeta = const VerificationMeta(
    'targetLanguage',
  );
  @override
  late final GeneratedColumn<String> targetLanguage = GeneratedColumn<String>(
    'target_language',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('fr'),
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 30,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('noun'),
  );
  static const VerificationMeta _frequencyScoreMeta = const VerificationMeta(
    'frequencyScore',
  );
  @override
  late final GeneratedColumn<double> frequencyScore = GeneratedColumn<double>(
    'frequency_score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(4.0),
  );
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
    'lemma',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    term,
    translation,
    contextSentence,
    category,
    level,
    language,
    targetLanguage,
    pos,
    frequencyScore,
    lemma,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('term')) {
      context.handle(
        _termMeta,
        term.isAcceptableOrUnknown(data['term']!, _termMeta),
      );
    } else if (isInserting) {
      context.missing(_termMeta);
    }
    if (data.containsKey('translation')) {
      context.handle(
        _translationMeta,
        translation.isAcceptableOrUnknown(
          data['translation']!,
          _translationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_translationMeta);
    }
    if (data.containsKey('context_sentence')) {
      context.handle(
        _contextSentenceMeta,
        contextSentence.isAcceptableOrUnknown(
          data['context_sentence']!,
          _contextSentenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contextSentenceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('target_language')) {
      context.handle(
        _targetLanguageMeta,
        targetLanguage.isAcceptableOrUnknown(
          data['target_language']!,
          _targetLanguageMeta,
        ),
      );
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    }
    if (data.containsKey('frequency_score')) {
      context.handle(
        _frequencyScoreMeta,
        frequencyScore.isAcceptableOrUnknown(
          data['frequency_score']!,
          _frequencyScoreMeta,
        ),
      );
    }
    if (data.containsKey('lemma')) {
      context.handle(
        _lemmaMeta,
        lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WordEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      term: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}term'],
      )!,
      translation: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}translation'],
      )!,
      contextSentence: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}context_sentence'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      targetLanguage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_language'],
      )!,
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      )!,
      frequencyScore: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}frequency_score'],
      )!,
      lemma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lemma'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WordsTableTable createAlias(String alias) {
    return $WordsTableTable(attachedDatabase, alias);
  }
}

class WordEntry extends DataClass implements Insertable<WordEntry> {
  final int id;
  final String term;
  final String translation;
  final String contextSentence;
  final String category;
  final String level;
  final String language;
  final String targetLanguage;
  final String pos;
  final double frequencyScore;
  final String? lemma;
  final DateTime createdAt;
  const WordEntry({
    required this.id,
    required this.term,
    required this.translation,
    required this.contextSentence,
    required this.category,
    required this.level,
    required this.language,
    required this.targetLanguage,
    required this.pos,
    required this.frequencyScore,
    this.lemma,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['term'] = Variable<String>(term);
    map['translation'] = Variable<String>(translation);
    map['context_sentence'] = Variable<String>(contextSentence);
    map['category'] = Variable<String>(category);
    map['level'] = Variable<String>(level);
    map['language'] = Variable<String>(language);
    map['target_language'] = Variable<String>(targetLanguage);
    map['pos'] = Variable<String>(pos);
    map['frequency_score'] = Variable<double>(frequencyScore);
    if (!nullToAbsent || lemma != null) {
      map['lemma'] = Variable<String>(lemma);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  WordsTableCompanion toCompanion(bool nullToAbsent) {
    return WordsTableCompanion(
      id: Value(id),
      term: Value(term),
      translation: Value(translation),
      contextSentence: Value(contextSentence),
      category: Value(category),
      level: Value(level),
      language: Value(language),
      targetLanguage: Value(targetLanguage),
      pos: Value(pos),
      frequencyScore: Value(frequencyScore),
      lemma: lemma == null && nullToAbsent
          ? const Value.absent()
          : Value(lemma),
      createdAt: Value(createdAt),
    );
  }

  factory WordEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordEntry(
      id: serializer.fromJson<int>(json['id']),
      term: serializer.fromJson<String>(json['term']),
      translation: serializer.fromJson<String>(json['translation']),
      contextSentence: serializer.fromJson<String>(json['contextSentence']),
      category: serializer.fromJson<String>(json['category']),
      level: serializer.fromJson<String>(json['level']),
      language: serializer.fromJson<String>(json['language']),
      targetLanguage: serializer.fromJson<String>(json['targetLanguage']),
      pos: serializer.fromJson<String>(json['pos']),
      frequencyScore: serializer.fromJson<double>(json['frequencyScore']),
      lemma: serializer.fromJson<String?>(json['lemma']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'term': serializer.toJson<String>(term),
      'translation': serializer.toJson<String>(translation),
      'contextSentence': serializer.toJson<String>(contextSentence),
      'category': serializer.toJson<String>(category),
      'level': serializer.toJson<String>(level),
      'language': serializer.toJson<String>(language),
      'targetLanguage': serializer.toJson<String>(targetLanguage),
      'pos': serializer.toJson<String>(pos),
      'frequencyScore': serializer.toJson<double>(frequencyScore),
      'lemma': serializer.toJson<String?>(lemma),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  WordEntry copyWith({
    int? id,
    String? term,
    String? translation,
    String? contextSentence,
    String? category,
    String? level,
    String? language,
    String? targetLanguage,
    String? pos,
    double? frequencyScore,
    Value<String?> lemma = const Value.absent(),
    DateTime? createdAt,
  }) => WordEntry(
    id: id ?? this.id,
    term: term ?? this.term,
    translation: translation ?? this.translation,
    contextSentence: contextSentence ?? this.contextSentence,
    category: category ?? this.category,
    level: level ?? this.level,
    language: language ?? this.language,
    targetLanguage: targetLanguage ?? this.targetLanguage,
    pos: pos ?? this.pos,
    frequencyScore: frequencyScore ?? this.frequencyScore,
    lemma: lemma.present ? lemma.value : this.lemma,
    createdAt: createdAt ?? this.createdAt,
  );
  WordEntry copyWithCompanion(WordsTableCompanion data) {
    return WordEntry(
      id: data.id.present ? data.id.value : this.id,
      term: data.term.present ? data.term.value : this.term,
      translation: data.translation.present
          ? data.translation.value
          : this.translation,
      contextSentence: data.contextSentence.present
          ? data.contextSentence.value
          : this.contextSentence,
      category: data.category.present ? data.category.value : this.category,
      level: data.level.present ? data.level.value : this.level,
      language: data.language.present ? data.language.value : this.language,
      targetLanguage: data.targetLanguage.present
          ? data.targetLanguage.value
          : this.targetLanguage,
      pos: data.pos.present ? data.pos.value : this.pos,
      frequencyScore: data.frequencyScore.present
          ? data.frequencyScore.value
          : this.frequencyScore,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordEntry(')
          ..write('id: $id, ')
          ..write('term: $term, ')
          ..write('translation: $translation, ')
          ..write('contextSentence: $contextSentence, ')
          ..write('category: $category, ')
          ..write('level: $level, ')
          ..write('language: $language, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('pos: $pos, ')
          ..write('frequencyScore: $frequencyScore, ')
          ..write('lemma: $lemma, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    term,
    translation,
    contextSentence,
    category,
    level,
    language,
    targetLanguage,
    pos,
    frequencyScore,
    lemma,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordEntry &&
          other.id == this.id &&
          other.term == this.term &&
          other.translation == this.translation &&
          other.contextSentence == this.contextSentence &&
          other.category == this.category &&
          other.level == this.level &&
          other.language == this.language &&
          other.targetLanguage == this.targetLanguage &&
          other.pos == this.pos &&
          other.frequencyScore == this.frequencyScore &&
          other.lemma == this.lemma &&
          other.createdAt == this.createdAt);
}

class WordsTableCompanion extends UpdateCompanion<WordEntry> {
  final Value<int> id;
  final Value<String> term;
  final Value<String> translation;
  final Value<String> contextSentence;
  final Value<String> category;
  final Value<String> level;
  final Value<String> language;
  final Value<String> targetLanguage;
  final Value<String> pos;
  final Value<double> frequencyScore;
  final Value<String?> lemma;
  final Value<DateTime> createdAt;
  const WordsTableCompanion({
    this.id = const Value.absent(),
    this.term = const Value.absent(),
    this.translation = const Value.absent(),
    this.contextSentence = const Value.absent(),
    this.category = const Value.absent(),
    this.level = const Value.absent(),
    this.language = const Value.absent(),
    this.targetLanguage = const Value.absent(),
    this.pos = const Value.absent(),
    this.frequencyScore = const Value.absent(),
    this.lemma = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WordsTableCompanion.insert({
    this.id = const Value.absent(),
    required String term,
    required String translation,
    required String contextSentence,
    required String category,
    required String level,
    this.language = const Value.absent(),
    this.targetLanguage = const Value.absent(),
    this.pos = const Value.absent(),
    this.frequencyScore = const Value.absent(),
    this.lemma = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : term = Value(term),
       translation = Value(translation),
       contextSentence = Value(contextSentence),
       category = Value(category),
       level = Value(level);
  static Insertable<WordEntry> custom({
    Expression<int>? id,
    Expression<String>? term,
    Expression<String>? translation,
    Expression<String>? contextSentence,
    Expression<String>? category,
    Expression<String>? level,
    Expression<String>? language,
    Expression<String>? targetLanguage,
    Expression<String>? pos,
    Expression<double>? frequencyScore,
    Expression<String>? lemma,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (term != null) 'term': term,
      if (translation != null) 'translation': translation,
      if (contextSentence != null) 'context_sentence': contextSentence,
      if (category != null) 'category': category,
      if (level != null) 'level': level,
      if (language != null) 'language': language,
      if (targetLanguage != null) 'target_language': targetLanguage,
      if (pos != null) 'pos': pos,
      if (frequencyScore != null) 'frequency_score': frequencyScore,
      if (lemma != null) 'lemma': lemma,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WordsTableCompanion copyWith({
    Value<int>? id,
    Value<String>? term,
    Value<String>? translation,
    Value<String>? contextSentence,
    Value<String>? category,
    Value<String>? level,
    Value<String>? language,
    Value<String>? targetLanguage,
    Value<String>? pos,
    Value<double>? frequencyScore,
    Value<String?>? lemma,
    Value<DateTime>? createdAt,
  }) {
    return WordsTableCompanion(
      id: id ?? this.id,
      term: term ?? this.term,
      translation: translation ?? this.translation,
      contextSentence: contextSentence ?? this.contextSentence,
      category: category ?? this.category,
      level: level ?? this.level,
      language: language ?? this.language,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      pos: pos ?? this.pos,
      frequencyScore: frequencyScore ?? this.frequencyScore,
      lemma: lemma ?? this.lemma,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (term.present) {
      map['term'] = Variable<String>(term.value);
    }
    if (translation.present) {
      map['translation'] = Variable<String>(translation.value);
    }
    if (contextSentence.present) {
      map['context_sentence'] = Variable<String>(contextSentence.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (targetLanguage.present) {
      map['target_language'] = Variable<String>(targetLanguage.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (frequencyScore.present) {
      map['frequency_score'] = Variable<double>(frequencyScore.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsTableCompanion(')
          ..write('id: $id, ')
          ..write('term: $term, ')
          ..write('translation: $translation, ')
          ..write('contextSentence: $contextSentence, ')
          ..write('category: $category, ')
          ..write('level: $level, ')
          ..write('language: $language, ')
          ..write('targetLanguage: $targetLanguage, ')
          ..write('pos: $pos, ')
          ..write('frequencyScore: $frequencyScore, ')
          ..write('lemma: $lemma, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $WordProgressTableTable extends WordProgressTable
    with TableInfo<$WordProgressTableTable, WordProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordProgressTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 20,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _easeFactorMeta = const VerificationMeta(
    'easeFactor',
  );
  @override
  late final GeneratedColumn<double> easeFactor = GeneratedColumn<double>(
    'ease_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(2.5),
  );
  static const VerificationMeta _intervalDaysMeta = const VerificationMeta(
    'intervalDays',
  );
  @override
  late final GeneratedColumn<int> intervalDays = GeneratedColumn<int>(
    'interval_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastReviewedAtMeta = const VerificationMeta(
    'lastReviewedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastReviewedAt =
      GeneratedColumn<DateTime>(
        'last_reviewed_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _nextReviewAtMeta = const VerificationMeta(
    'nextReviewAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextReviewAt = GeneratedColumn<DateTime>(
    'next_review_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _consecutiveSuccessesMeta =
      const VerificationMeta('consecutiveSuccesses');
  @override
  late final GeneratedColumn<int> consecutiveSuccesses = GeneratedColumn<int>(
    'consecutive_successes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordId,
    status,
    step,
    easeFactor,
    intervalDays,
    lastReviewedAt,
    nextReviewAt,
    consecutiveSuccesses,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_progress_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    }
    if (data.containsKey('ease_factor')) {
      context.handle(
        _easeFactorMeta,
        easeFactor.isAcceptableOrUnknown(data['ease_factor']!, _easeFactorMeta),
      );
    }
    if (data.containsKey('interval_days')) {
      context.handle(
        _intervalDaysMeta,
        intervalDays.isAcceptableOrUnknown(
          data['interval_days']!,
          _intervalDaysMeta,
        ),
      );
    }
    if (data.containsKey('last_reviewed_at')) {
      context.handle(
        _lastReviewedAtMeta,
        lastReviewedAt.isAcceptableOrUnknown(
          data['last_reviewed_at']!,
          _lastReviewedAtMeta,
        ),
      );
    }
    if (data.containsKey('next_review_at')) {
      context.handle(
        _nextReviewAtMeta,
        nextReviewAt.isAcceptableOrUnknown(
          data['next_review_at']!,
          _nextReviewAtMeta,
        ),
      );
    }
    if (data.containsKey('consecutive_successes')) {
      context.handle(
        _consecutiveSuccessesMeta,
        consecutiveSuccesses.isAcceptableOrUnknown(
          data['consecutive_successes']!,
          _consecutiveSuccessesMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WordProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      )!,
      easeFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}ease_factor'],
      )!,
      intervalDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_days'],
      )!,
      lastReviewedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_reviewed_at'],
      ),
      nextReviewAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_review_at'],
      ),
      consecutiveSuccesses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}consecutive_successes'],
      )!,
    );
  }

  @override
  $WordProgressTableTable createAlias(String alias) {
    return $WordProgressTableTable(attachedDatabase, alias);
  }
}

class WordProgressEntry extends DataClass
    implements Insertable<WordProgressEntry> {
  final int id;
  final int wordId;
  final String status;
  final int step;
  final double easeFactor;
  final int intervalDays;
  final DateTime? lastReviewedAt;
  final DateTime? nextReviewAt;
  final int consecutiveSuccesses;
  const WordProgressEntry({
    required this.id,
    required this.wordId,
    required this.status,
    required this.step,
    required this.easeFactor,
    required this.intervalDays,
    this.lastReviewedAt,
    this.nextReviewAt,
    required this.consecutiveSuccesses,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<int>(wordId);
    map['status'] = Variable<String>(status);
    map['step'] = Variable<int>(step);
    map['ease_factor'] = Variable<double>(easeFactor);
    map['interval_days'] = Variable<int>(intervalDays);
    if (!nullToAbsent || lastReviewedAt != null) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt);
    }
    if (!nullToAbsent || nextReviewAt != null) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt);
    }
    map['consecutive_successes'] = Variable<int>(consecutiveSuccesses);
    return map;
  }

  WordProgressTableCompanion toCompanion(bool nullToAbsent) {
    return WordProgressTableCompanion(
      id: Value(id),
      wordId: Value(wordId),
      status: Value(status),
      step: Value(step),
      easeFactor: Value(easeFactor),
      intervalDays: Value(intervalDays),
      lastReviewedAt: lastReviewedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewedAt),
      nextReviewAt: nextReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextReviewAt),
      consecutiveSuccesses: Value(consecutiveSuccesses),
    );
  }

  factory WordProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordProgressEntry(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int>(json['wordId']),
      status: serializer.fromJson<String>(json['status']),
      step: serializer.fromJson<int>(json['step']),
      easeFactor: serializer.fromJson<double>(json['easeFactor']),
      intervalDays: serializer.fromJson<int>(json['intervalDays']),
      lastReviewedAt: serializer.fromJson<DateTime?>(json['lastReviewedAt']),
      nextReviewAt: serializer.fromJson<DateTime?>(json['nextReviewAt']),
      consecutiveSuccesses: serializer.fromJson<int>(
        json['consecutiveSuccesses'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int>(wordId),
      'status': serializer.toJson<String>(status),
      'step': serializer.toJson<int>(step),
      'easeFactor': serializer.toJson<double>(easeFactor),
      'intervalDays': serializer.toJson<int>(intervalDays),
      'lastReviewedAt': serializer.toJson<DateTime?>(lastReviewedAt),
      'nextReviewAt': serializer.toJson<DateTime?>(nextReviewAt),
      'consecutiveSuccesses': serializer.toJson<int>(consecutiveSuccesses),
    };
  }

  WordProgressEntry copyWith({
    int? id,
    int? wordId,
    String? status,
    int? step,
    double? easeFactor,
    int? intervalDays,
    Value<DateTime?> lastReviewedAt = const Value.absent(),
    Value<DateTime?> nextReviewAt = const Value.absent(),
    int? consecutiveSuccesses,
  }) => WordProgressEntry(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    status: status ?? this.status,
    step: step ?? this.step,
    easeFactor: easeFactor ?? this.easeFactor,
    intervalDays: intervalDays ?? this.intervalDays,
    lastReviewedAt: lastReviewedAt.present
        ? lastReviewedAt.value
        : this.lastReviewedAt,
    nextReviewAt: nextReviewAt.present ? nextReviewAt.value : this.nextReviewAt,
    consecutiveSuccesses: consecutiveSuccesses ?? this.consecutiveSuccesses,
  );
  WordProgressEntry copyWithCompanion(WordProgressTableCompanion data) {
    return WordProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      status: data.status.present ? data.status.value : this.status,
      step: data.step.present ? data.step.value : this.step,
      easeFactor: data.easeFactor.present
          ? data.easeFactor.value
          : this.easeFactor,
      intervalDays: data.intervalDays.present
          ? data.intervalDays.value
          : this.intervalDays,
      lastReviewedAt: data.lastReviewedAt.present
          ? data.lastReviewedAt.value
          : this.lastReviewedAt,
      nextReviewAt: data.nextReviewAt.present
          ? data.nextReviewAt.value
          : this.nextReviewAt,
      consecutiveSuccesses: data.consecutiveSuccesses.present
          ? data.consecutiveSuccesses.value
          : this.consecutiveSuccesses,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordProgressEntry(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('status: $status, ')
          ..write('step: $step, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('consecutiveSuccesses: $consecutiveSuccesses')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wordId,
    status,
    step,
    easeFactor,
    intervalDays,
    lastReviewedAt,
    nextReviewAt,
    consecutiveSuccesses,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordProgressEntry &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.status == this.status &&
          other.step == this.step &&
          other.easeFactor == this.easeFactor &&
          other.intervalDays == this.intervalDays &&
          other.lastReviewedAt == this.lastReviewedAt &&
          other.nextReviewAt == this.nextReviewAt &&
          other.consecutiveSuccesses == this.consecutiveSuccesses);
}

class WordProgressTableCompanion extends UpdateCompanion<WordProgressEntry> {
  final Value<int> id;
  final Value<int> wordId;
  final Value<String> status;
  final Value<int> step;
  final Value<double> easeFactor;
  final Value<int> intervalDays;
  final Value<DateTime?> lastReviewedAt;
  final Value<DateTime?> nextReviewAt;
  final Value<int> consecutiveSuccesses;
  const WordProgressTableCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.status = const Value.absent(),
    this.step = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.consecutiveSuccesses = const Value.absent(),
  });
  WordProgressTableCompanion.insert({
    this.id = const Value.absent(),
    required int wordId,
    required String status,
    this.step = const Value.absent(),
    this.easeFactor = const Value.absent(),
    this.intervalDays = const Value.absent(),
    this.lastReviewedAt = const Value.absent(),
    this.nextReviewAt = const Value.absent(),
    this.consecutiveSuccesses = const Value.absent(),
  }) : wordId = Value(wordId),
       status = Value(status);
  static Insertable<WordProgressEntry> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<String>? status,
    Expression<int>? step,
    Expression<double>? easeFactor,
    Expression<int>? intervalDays,
    Expression<DateTime>? lastReviewedAt,
    Expression<DateTime>? nextReviewAt,
    Expression<int>? consecutiveSuccesses,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (status != null) 'status': status,
      if (step != null) 'step': step,
      if (easeFactor != null) 'ease_factor': easeFactor,
      if (intervalDays != null) 'interval_days': intervalDays,
      if (lastReviewedAt != null) 'last_reviewed_at': lastReviewedAt,
      if (nextReviewAt != null) 'next_review_at': nextReviewAt,
      if (consecutiveSuccesses != null)
        'consecutive_successes': consecutiveSuccesses,
    });
  }

  WordProgressTableCompanion copyWith({
    Value<int>? id,
    Value<int>? wordId,
    Value<String>? status,
    Value<int>? step,
    Value<double>? easeFactor,
    Value<int>? intervalDays,
    Value<DateTime?>? lastReviewedAt,
    Value<DateTime?>? nextReviewAt,
    Value<int>? consecutiveSuccesses,
  }) {
    return WordProgressTableCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      status: status ?? this.status,
      step: step ?? this.step,
      easeFactor: easeFactor ?? this.easeFactor,
      intervalDays: intervalDays ?? this.intervalDays,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
      nextReviewAt: nextReviewAt ?? this.nextReviewAt,
      consecutiveSuccesses: consecutiveSuccesses ?? this.consecutiveSuccesses,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (easeFactor.present) {
      map['ease_factor'] = Variable<double>(easeFactor.value);
    }
    if (intervalDays.present) {
      map['interval_days'] = Variable<int>(intervalDays.value);
    }
    if (lastReviewedAt.present) {
      map['last_reviewed_at'] = Variable<DateTime>(lastReviewedAt.value);
    }
    if (nextReviewAt.present) {
      map['next_review_at'] = Variable<DateTime>(nextReviewAt.value);
    }
    if (consecutiveSuccesses.present) {
      map['consecutive_successes'] = Variable<int>(consecutiveSuccesses.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordProgressTableCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('status: $status, ')
          ..write('step: $step, ')
          ..write('easeFactor: $easeFactor, ')
          ..write('intervalDays: $intervalDays, ')
          ..write('lastReviewedAt: $lastReviewedAt, ')
          ..write('nextReviewAt: $nextReviewAt, ')
          ..write('consecutiveSuccesses: $consecutiveSuccesses')
          ..write(')'))
        .toString();
  }
}

class $UnimorphFormsTableTable extends UnimorphFormsTable
    with TableInfo<$UnimorphFormsTableTable, UnimorphFormEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UnimorphFormsTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<int> wordId = GeneratedColumn<int>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formMeta = const VerificationMeta('form');
  @override
  late final GeneratedColumn<String> form = GeneratedColumn<String>(
    'form',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unimorphTagMeta = const VerificationMeta(
    'unimorphTag',
  );
  @override
  late final GeneratedColumn<String> unimorphTag = GeneratedColumn<String>(
    'unimorph_tag',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 100,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelFrMeta = const VerificationMeta(
    'labelFr',
  );
  @override
  late final GeneratedColumn<String> labelFr = GeneratedColumn<String>(
    'label_fr',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isIrregularMeta = const VerificationMeta(
    'isIrregular',
  );
  @override
  late final GeneratedColumn<bool> isIrregular = GeneratedColumn<bool>(
    'is_irregular',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_irregular" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordId,
    form,
    unimorphTag,
    labelFr,
    isIrregular,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'unimorph_forms_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<UnimorphFormEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('form')) {
      context.handle(
        _formMeta,
        form.isAcceptableOrUnknown(data['form']!, _formMeta),
      );
    } else if (isInserting) {
      context.missing(_formMeta);
    }
    if (data.containsKey('unimorph_tag')) {
      context.handle(
        _unimorphTagMeta,
        unimorphTag.isAcceptableOrUnknown(
          data['unimorph_tag']!,
          _unimorphTagMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_unimorphTagMeta);
    }
    if (data.containsKey('label_fr')) {
      context.handle(
        _labelFrMeta,
        labelFr.isAcceptableOrUnknown(data['label_fr']!, _labelFrMeta),
      );
    } else if (isInserting) {
      context.missing(_labelFrMeta);
    }
    if (data.containsKey('is_irregular')) {
      context.handle(
        _isIrregularMeta,
        isIrregular.isAcceptableOrUnknown(
          data['is_irregular']!,
          _isIrregularMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UnimorphFormEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UnimorphFormEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_id'],
      )!,
      form: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}form'],
      )!,
      unimorphTag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unimorph_tag'],
      )!,
      labelFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_fr'],
      )!,
      isIrregular: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_irregular'],
      )!,
    );
  }

  @override
  $UnimorphFormsTableTable createAlias(String alias) {
    return $UnimorphFormsTableTable(attachedDatabase, alias);
  }
}

class UnimorphFormEntry extends DataClass
    implements Insertable<UnimorphFormEntry> {
  final int id;
  final int wordId;
  final String form;
  final String unimorphTag;
  final String labelFr;
  final bool isIrregular;
  const UnimorphFormEntry({
    required this.id,
    required this.wordId,
    required this.form,
    required this.unimorphTag,
    required this.labelFr,
    required this.isIrregular,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['word_id'] = Variable<int>(wordId);
    map['form'] = Variable<String>(form);
    map['unimorph_tag'] = Variable<String>(unimorphTag);
    map['label_fr'] = Variable<String>(labelFr);
    map['is_irregular'] = Variable<bool>(isIrregular);
    return map;
  }

  UnimorphFormsTableCompanion toCompanion(bool nullToAbsent) {
    return UnimorphFormsTableCompanion(
      id: Value(id),
      wordId: Value(wordId),
      form: Value(form),
      unimorphTag: Value(unimorphTag),
      labelFr: Value(labelFr),
      isIrregular: Value(isIrregular),
    );
  }

  factory UnimorphFormEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UnimorphFormEntry(
      id: serializer.fromJson<int>(json['id']),
      wordId: serializer.fromJson<int>(json['wordId']),
      form: serializer.fromJson<String>(json['form']),
      unimorphTag: serializer.fromJson<String>(json['unimorphTag']),
      labelFr: serializer.fromJson<String>(json['labelFr']),
      isIrregular: serializer.fromJson<bool>(json['isIrregular']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'wordId': serializer.toJson<int>(wordId),
      'form': serializer.toJson<String>(form),
      'unimorphTag': serializer.toJson<String>(unimorphTag),
      'labelFr': serializer.toJson<String>(labelFr),
      'isIrregular': serializer.toJson<bool>(isIrregular),
    };
  }

  UnimorphFormEntry copyWith({
    int? id,
    int? wordId,
    String? form,
    String? unimorphTag,
    String? labelFr,
    bool? isIrregular,
  }) => UnimorphFormEntry(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    form: form ?? this.form,
    unimorphTag: unimorphTag ?? this.unimorphTag,
    labelFr: labelFr ?? this.labelFr,
    isIrregular: isIrregular ?? this.isIrregular,
  );
  UnimorphFormEntry copyWithCompanion(UnimorphFormsTableCompanion data) {
    return UnimorphFormEntry(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      form: data.form.present ? data.form.value : this.form,
      unimorphTag: data.unimorphTag.present
          ? data.unimorphTag.value
          : this.unimorphTag,
      labelFr: data.labelFr.present ? data.labelFr.value : this.labelFr,
      isIrregular: data.isIrregular.present
          ? data.isIrregular.value
          : this.isIrregular,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UnimorphFormEntry(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('form: $form, ')
          ..write('unimorphTag: $unimorphTag, ')
          ..write('labelFr: $labelFr, ')
          ..write('isIrregular: $isIrregular')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, wordId, form, unimorphTag, labelFr, isIrregular);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UnimorphFormEntry &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.form == this.form &&
          other.unimorphTag == this.unimorphTag &&
          other.labelFr == this.labelFr &&
          other.isIrregular == this.isIrregular);
}

class UnimorphFormsTableCompanion extends UpdateCompanion<UnimorphFormEntry> {
  final Value<int> id;
  final Value<int> wordId;
  final Value<String> form;
  final Value<String> unimorphTag;
  final Value<String> labelFr;
  final Value<bool> isIrregular;
  const UnimorphFormsTableCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.form = const Value.absent(),
    this.unimorphTag = const Value.absent(),
    this.labelFr = const Value.absent(),
    this.isIrregular = const Value.absent(),
  });
  UnimorphFormsTableCompanion.insert({
    this.id = const Value.absent(),
    required int wordId,
    required String form,
    required String unimorphTag,
    required String labelFr,
    this.isIrregular = const Value.absent(),
  }) : wordId = Value(wordId),
       form = Value(form),
       unimorphTag = Value(unimorphTag),
       labelFr = Value(labelFr);
  static Insertable<UnimorphFormEntry> custom({
    Expression<int>? id,
    Expression<int>? wordId,
    Expression<String>? form,
    Expression<String>? unimorphTag,
    Expression<String>? labelFr,
    Expression<bool>? isIrregular,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (form != null) 'form': form,
      if (unimorphTag != null) 'unimorph_tag': unimorphTag,
      if (labelFr != null) 'label_fr': labelFr,
      if (isIrregular != null) 'is_irregular': isIrregular,
    });
  }

  UnimorphFormsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? wordId,
    Value<String>? form,
    Value<String>? unimorphTag,
    Value<String>? labelFr,
    Value<bool>? isIrregular,
  }) {
    return UnimorphFormsTableCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      form: form ?? this.form,
      unimorphTag: unimorphTag ?? this.unimorphTag,
      labelFr: labelFr ?? this.labelFr,
      isIrregular: isIrregular ?? this.isIrregular,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<int>(wordId.value);
    }
    if (form.present) {
      map['form'] = Variable<String>(form.value);
    }
    if (unimorphTag.present) {
      map['unimorph_tag'] = Variable<String>(unimorphTag.value);
    }
    if (labelFr.present) {
      map['label_fr'] = Variable<String>(labelFr.value);
    }
    if (isIrregular.present) {
      map['is_irregular'] = Variable<bool>(isIrregular.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UnimorphFormsTableCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('form: $form, ')
          ..write('unimorphTag: $unimorphTag, ')
          ..write('labelFr: $labelFr, ')
          ..write('isIrregular: $isIrregular')
          ..write(')'))
        .toString();
  }
}

class $GrammarRulesTableTable extends GrammarRulesTable
    with TableInfo<$GrammarRulesTableTable, GrammarRuleEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarRulesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _ruleCodeMeta = const VerificationMeta(
    'ruleCode',
  );
  @override
  late final GeneratedColumn<String> ruleCode = GeneratedColumn<String>(
    'rule_code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 50,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _explanationFrMeta = const VerificationMeta(
    'explanationFr',
  );
  @override
  late final GeneratedColumn<String> explanationFr = GeneratedColumn<String>(
    'explanation_fr',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _formulaPatternMeta = const VerificationMeta(
    'formulaPattern',
  );
  @override
  late final GeneratedColumn<String> formulaPattern = GeneratedColumn<String>(
    'formula_pattern',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    language,
    ruleCode,
    title,
    level,
    explanationFr,
    formulaPattern,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_rules_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarRuleEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    }
    if (data.containsKey('rule_code')) {
      context.handle(
        _ruleCodeMeta,
        ruleCode.isAcceptableOrUnknown(data['rule_code']!, _ruleCodeMeta),
      );
    } else if (isInserting) {
      context.missing(_ruleCodeMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('explanation_fr')) {
      context.handle(
        _explanationFrMeta,
        explanationFr.isAcceptableOrUnknown(
          data['explanation_fr']!,
          _explanationFrMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_explanationFrMeta);
    }
    if (data.containsKey('formula_pattern')) {
      context.handle(
        _formulaPatternMeta,
        formulaPattern.isAcceptableOrUnknown(
          data['formula_pattern']!,
          _formulaPatternMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_formulaPatternMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GrammarRuleEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarRuleEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      ruleCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rule_code'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      explanationFr: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}explanation_fr'],
      )!,
      formulaPattern: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}formula_pattern'],
      )!,
    );
  }

  @override
  $GrammarRulesTableTable createAlias(String alias) {
    return $GrammarRulesTableTable(attachedDatabase, alias);
  }
}

class GrammarRuleEntry extends DataClass
    implements Insertable<GrammarRuleEntry> {
  final int id;
  final String language;
  final String ruleCode;
  final String title;
  final String level;
  final String explanationFr;
  final String formulaPattern;
  const GrammarRuleEntry({
    required this.id,
    required this.language,
    required this.ruleCode,
    required this.title,
    required this.level,
    required this.explanationFr,
    required this.formulaPattern,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['language'] = Variable<String>(language);
    map['rule_code'] = Variable<String>(ruleCode);
    map['title'] = Variable<String>(title);
    map['level'] = Variable<String>(level);
    map['explanation_fr'] = Variable<String>(explanationFr);
    map['formula_pattern'] = Variable<String>(formulaPattern);
    return map;
  }

  GrammarRulesTableCompanion toCompanion(bool nullToAbsent) {
    return GrammarRulesTableCompanion(
      id: Value(id),
      language: Value(language),
      ruleCode: Value(ruleCode),
      title: Value(title),
      level: Value(level),
      explanationFr: Value(explanationFr),
      formulaPattern: Value(formulaPattern),
    );
  }

  factory GrammarRuleEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarRuleEntry(
      id: serializer.fromJson<int>(json['id']),
      language: serializer.fromJson<String>(json['language']),
      ruleCode: serializer.fromJson<String>(json['ruleCode']),
      title: serializer.fromJson<String>(json['title']),
      level: serializer.fromJson<String>(json['level']),
      explanationFr: serializer.fromJson<String>(json['explanationFr']),
      formulaPattern: serializer.fromJson<String>(json['formulaPattern']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'language': serializer.toJson<String>(language),
      'ruleCode': serializer.toJson<String>(ruleCode),
      'title': serializer.toJson<String>(title),
      'level': serializer.toJson<String>(level),
      'explanationFr': serializer.toJson<String>(explanationFr),
      'formulaPattern': serializer.toJson<String>(formulaPattern),
    };
  }

  GrammarRuleEntry copyWith({
    int? id,
    String? language,
    String? ruleCode,
    String? title,
    String? level,
    String? explanationFr,
    String? formulaPattern,
  }) => GrammarRuleEntry(
    id: id ?? this.id,
    language: language ?? this.language,
    ruleCode: ruleCode ?? this.ruleCode,
    title: title ?? this.title,
    level: level ?? this.level,
    explanationFr: explanationFr ?? this.explanationFr,
    formulaPattern: formulaPattern ?? this.formulaPattern,
  );
  GrammarRuleEntry copyWithCompanion(GrammarRulesTableCompanion data) {
    return GrammarRuleEntry(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      ruleCode: data.ruleCode.present ? data.ruleCode.value : this.ruleCode,
      title: data.title.present ? data.title.value : this.title,
      level: data.level.present ? data.level.value : this.level,
      explanationFr: data.explanationFr.present
          ? data.explanationFr.value
          : this.explanationFr,
      formulaPattern: data.formulaPattern.present
          ? data.formulaPattern.value
          : this.formulaPattern,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarRuleEntry(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('ruleCode: $ruleCode, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('explanationFr: $explanationFr, ')
          ..write('formulaPattern: $formulaPattern')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    language,
    ruleCode,
    title,
    level,
    explanationFr,
    formulaPattern,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarRuleEntry &&
          other.id == this.id &&
          other.language == this.language &&
          other.ruleCode == this.ruleCode &&
          other.title == this.title &&
          other.level == this.level &&
          other.explanationFr == this.explanationFr &&
          other.formulaPattern == this.formulaPattern);
}

class GrammarRulesTableCompanion extends UpdateCompanion<GrammarRuleEntry> {
  final Value<int> id;
  final Value<String> language;
  final Value<String> ruleCode;
  final Value<String> title;
  final Value<String> level;
  final Value<String> explanationFr;
  final Value<String> formulaPattern;
  const GrammarRulesTableCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.ruleCode = const Value.absent(),
    this.title = const Value.absent(),
    this.level = const Value.absent(),
    this.explanationFr = const Value.absent(),
    this.formulaPattern = const Value.absent(),
  });
  GrammarRulesTableCompanion.insert({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    required String ruleCode,
    required String title,
    required String level,
    required String explanationFr,
    required String formulaPattern,
  }) : ruleCode = Value(ruleCode),
       title = Value(title),
       level = Value(level),
       explanationFr = Value(explanationFr),
       formulaPattern = Value(formulaPattern);
  static Insertable<GrammarRuleEntry> custom({
    Expression<int>? id,
    Expression<String>? language,
    Expression<String>? ruleCode,
    Expression<String>? title,
    Expression<String>? level,
    Expression<String>? explanationFr,
    Expression<String>? formulaPattern,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (ruleCode != null) 'rule_code': ruleCode,
      if (title != null) 'title': title,
      if (level != null) 'level': level,
      if (explanationFr != null) 'explanation_fr': explanationFr,
      if (formulaPattern != null) 'formula_pattern': formulaPattern,
    });
  }

  GrammarRulesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? language,
    Value<String>? ruleCode,
    Value<String>? title,
    Value<String>? level,
    Value<String>? explanationFr,
    Value<String>? formulaPattern,
  }) {
    return GrammarRulesTableCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      ruleCode: ruleCode ?? this.ruleCode,
      title: title ?? this.title,
      level: level ?? this.level,
      explanationFr: explanationFr ?? this.explanationFr,
      formulaPattern: formulaPattern ?? this.formulaPattern,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (ruleCode.present) {
      map['rule_code'] = Variable<String>(ruleCode.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (explanationFr.present) {
      map['explanation_fr'] = Variable<String>(explanationFr.value);
    }
    if (formulaPattern.present) {
      map['formula_pattern'] = Variable<String>(formulaPattern.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarRulesTableCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('ruleCode: $ruleCode, ')
          ..write('title: $title, ')
          ..write('level: $level, ')
          ..write('explanationFr: $explanationFr, ')
          ..write('formulaPattern: $formulaPattern')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WordsTableTable wordsTable = $WordsTableTable(this);
  late final $WordProgressTableTable wordProgressTable =
      $WordProgressTableTable(this);
  late final $UnimorphFormsTableTable unimorphFormsTable =
      $UnimorphFormsTableTable(this);
  late final $GrammarRulesTableTable grammarRulesTable =
      $GrammarRulesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    wordsTable,
    wordProgressTable,
    unimorphFormsTable,
    grammarRulesTable,
  ];
}

typedef $$WordsTableTableCreateCompanionBuilder =
    WordsTableCompanion Function({
      Value<int> id,
      required String term,
      required String translation,
      required String contextSentence,
      required String category,
      required String level,
      Value<String> language,
      Value<String> targetLanguage,
      Value<String> pos,
      Value<double> frequencyScore,
      Value<String?> lemma,
      Value<DateTime> createdAt,
    });
typedef $$WordsTableTableUpdateCompanionBuilder =
    WordsTableCompanion Function({
      Value<int> id,
      Value<String> term,
      Value<String> translation,
      Value<String> contextSentence,
      Value<String> category,
      Value<String> level,
      Value<String> language,
      Value<String> targetLanguage,
      Value<String> pos,
      Value<double> frequencyScore,
      Value<String?> lemma,
      Value<DateTime> createdAt,
    });

class $$WordsTableTableFilterComposer
    extends Composer<_$AppDatabase, $WordsTableTable> {
  $$WordsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get term => $composableBuilder(
    column: $table.term,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contextSentence => $composableBuilder(
    column: $table.contextSentence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get frequencyScore => $composableBuilder(
    column: $table.frequencyScore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTableTable> {
  $$WordsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get term => $composableBuilder(
    column: $table.term,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contextSentence => $composableBuilder(
    column: $table.contextSentence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get frequencyScore => $composableBuilder(
    column: $table.frequencyScore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTableTable> {
  $$WordsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get term =>
      $composableBuilder(column: $table.term, builder: (column) => column);

  GeneratedColumn<String> get translation => $composableBuilder(
    column: $table.translation,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contextSentence => $composableBuilder(
    column: $table.contextSentence,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get targetLanguage => $composableBuilder(
    column: $table.targetLanguage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<double> get frequencyScore => $composableBuilder(
    column: $table.frequencyScore,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WordsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTableTable,
          WordEntry,
          $$WordsTableTableFilterComposer,
          $$WordsTableTableOrderingComposer,
          $$WordsTableTableAnnotationComposer,
          $$WordsTableTableCreateCompanionBuilder,
          $$WordsTableTableUpdateCompanionBuilder,
          (
            WordEntry,
            BaseReferences<_$AppDatabase, $WordsTableTable, WordEntry>,
          ),
          WordEntry,
          PrefetchHooks Function()
        > {
  $$WordsTableTableTableManager(_$AppDatabase db, $WordsTableTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> term = const Value.absent(),
                Value<String> translation = const Value.absent(),
                Value<String> contextSentence = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> targetLanguage = const Value.absent(),
                Value<String> pos = const Value.absent(),
                Value<double> frequencyScore = const Value.absent(),
                Value<String?> lemma = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WordsTableCompanion(
                id: id,
                term: term,
                translation: translation,
                contextSentence: contextSentence,
                category: category,
                level: level,
                language: language,
                targetLanguage: targetLanguage,
                pos: pos,
                frequencyScore: frequencyScore,
                lemma: lemma,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String term,
                required String translation,
                required String contextSentence,
                required String category,
                required String level,
                Value<String> language = const Value.absent(),
                Value<String> targetLanguage = const Value.absent(),
                Value<String> pos = const Value.absent(),
                Value<double> frequencyScore = const Value.absent(),
                Value<String?> lemma = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => WordsTableCompanion.insert(
                id: id,
                term: term,
                translation: translation,
                contextSentence: contextSentence,
                category: category,
                level: level,
                language: language,
                targetLanguage: targetLanguage,
                pos: pos,
                frequencyScore: frequencyScore,
                lemma: lemma,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTableTable,
      WordEntry,
      $$WordsTableTableFilterComposer,
      $$WordsTableTableOrderingComposer,
      $$WordsTableTableAnnotationComposer,
      $$WordsTableTableCreateCompanionBuilder,
      $$WordsTableTableUpdateCompanionBuilder,
      (WordEntry, BaseReferences<_$AppDatabase, $WordsTableTable, WordEntry>),
      WordEntry,
      PrefetchHooks Function()
    >;
typedef $$WordProgressTableTableCreateCompanionBuilder =
    WordProgressTableCompanion Function({
      Value<int> id,
      required int wordId,
      required String status,
      Value<int> step,
      Value<double> easeFactor,
      Value<int> intervalDays,
      Value<DateTime?> lastReviewedAt,
      Value<DateTime?> nextReviewAt,
      Value<int> consecutiveSuccesses,
    });
typedef $$WordProgressTableTableUpdateCompanionBuilder =
    WordProgressTableCompanion Function({
      Value<int> id,
      Value<int> wordId,
      Value<String> status,
      Value<int> step,
      Value<double> easeFactor,
      Value<int> intervalDays,
      Value<DateTime?> lastReviewedAt,
      Value<DateTime?> nextReviewAt,
      Value<int> consecutiveSuccesses,
    });

class $$WordProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $WordProgressTableTable> {
  $$WordProgressTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get consecutiveSuccesses => $composableBuilder(
    column: $table.consecutiveSuccesses,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $WordProgressTableTable> {
  $$WordProgressTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get consecutiveSuccesses => $composableBuilder(
    column: $table.consecutiveSuccesses,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordProgressTableTable> {
  $$WordProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<double> get easeFactor => $composableBuilder(
    column: $table.easeFactor,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalDays => $composableBuilder(
    column: $table.intervalDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastReviewedAt => $composableBuilder(
    column: $table.lastReviewedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextReviewAt => $composableBuilder(
    column: $table.nextReviewAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get consecutiveSuccesses => $composableBuilder(
    column: $table.consecutiveSuccesses,
    builder: (column) => column,
  );
}

class $$WordProgressTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordProgressTableTable,
          WordProgressEntry,
          $$WordProgressTableTableFilterComposer,
          $$WordProgressTableTableOrderingComposer,
          $$WordProgressTableTableAnnotationComposer,
          $$WordProgressTableTableCreateCompanionBuilder,
          $$WordProgressTableTableUpdateCompanionBuilder,
          (
            WordProgressEntry,
            BaseReferences<
              _$AppDatabase,
              $WordProgressTableTable,
              WordProgressEntry
            >,
          ),
          WordProgressEntry,
          PrefetchHooks Function()
        > {
  $$WordProgressTableTableTableManager(
    _$AppDatabase db,
    $WordProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordProgressTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> step = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime?> nextReviewAt = const Value.absent(),
                Value<int> consecutiveSuccesses = const Value.absent(),
              }) => WordProgressTableCompanion(
                id: id,
                wordId: wordId,
                status: status,
                step: step,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                lastReviewedAt: lastReviewedAt,
                nextReviewAt: nextReviewAt,
                consecutiveSuccesses: consecutiveSuccesses,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int wordId,
                required String status,
                Value<int> step = const Value.absent(),
                Value<double> easeFactor = const Value.absent(),
                Value<int> intervalDays = const Value.absent(),
                Value<DateTime?> lastReviewedAt = const Value.absent(),
                Value<DateTime?> nextReviewAt = const Value.absent(),
                Value<int> consecutiveSuccesses = const Value.absent(),
              }) => WordProgressTableCompanion.insert(
                id: id,
                wordId: wordId,
                status: status,
                step: step,
                easeFactor: easeFactor,
                intervalDays: intervalDays,
                lastReviewedAt: lastReviewedAt,
                nextReviewAt: nextReviewAt,
                consecutiveSuccesses: consecutiveSuccesses,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordProgressTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordProgressTableTable,
      WordProgressEntry,
      $$WordProgressTableTableFilterComposer,
      $$WordProgressTableTableOrderingComposer,
      $$WordProgressTableTableAnnotationComposer,
      $$WordProgressTableTableCreateCompanionBuilder,
      $$WordProgressTableTableUpdateCompanionBuilder,
      (
        WordProgressEntry,
        BaseReferences<
          _$AppDatabase,
          $WordProgressTableTable,
          WordProgressEntry
        >,
      ),
      WordProgressEntry,
      PrefetchHooks Function()
    >;
typedef $$UnimorphFormsTableTableCreateCompanionBuilder =
    UnimorphFormsTableCompanion Function({
      Value<int> id,
      required int wordId,
      required String form,
      required String unimorphTag,
      required String labelFr,
      Value<bool> isIrregular,
    });
typedef $$UnimorphFormsTableTableUpdateCompanionBuilder =
    UnimorphFormsTableCompanion Function({
      Value<int> id,
      Value<int> wordId,
      Value<String> form,
      Value<String> unimorphTag,
      Value<String> labelFr,
      Value<bool> isIrregular,
    });

class $$UnimorphFormsTableTableFilterComposer
    extends Composer<_$AppDatabase, $UnimorphFormsTableTable> {
  $$UnimorphFormsTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unimorphTag => $composableBuilder(
    column: $table.unimorphTag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get labelFr => $composableBuilder(
    column: $table.labelFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIrregular => $composableBuilder(
    column: $table.isIrregular,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UnimorphFormsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $UnimorphFormsTableTable> {
  $$UnimorphFormsTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get form => $composableBuilder(
    column: $table.form,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unimorphTag => $composableBuilder(
    column: $table.unimorphTag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get labelFr => $composableBuilder(
    column: $table.labelFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIrregular => $composableBuilder(
    column: $table.isIrregular,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UnimorphFormsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $UnimorphFormsTableTable> {
  $$UnimorphFormsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get form =>
      $composableBuilder(column: $table.form, builder: (column) => column);

  GeneratedColumn<String> get unimorphTag => $composableBuilder(
    column: $table.unimorphTag,
    builder: (column) => column,
  );

  GeneratedColumn<String> get labelFr =>
      $composableBuilder(column: $table.labelFr, builder: (column) => column);

  GeneratedColumn<bool> get isIrregular => $composableBuilder(
    column: $table.isIrregular,
    builder: (column) => column,
  );
}

class $$UnimorphFormsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UnimorphFormsTableTable,
          UnimorphFormEntry,
          $$UnimorphFormsTableTableFilterComposer,
          $$UnimorphFormsTableTableOrderingComposer,
          $$UnimorphFormsTableTableAnnotationComposer,
          $$UnimorphFormsTableTableCreateCompanionBuilder,
          $$UnimorphFormsTableTableUpdateCompanionBuilder,
          (
            UnimorphFormEntry,
            BaseReferences<
              _$AppDatabase,
              $UnimorphFormsTableTable,
              UnimorphFormEntry
            >,
          ),
          UnimorphFormEntry,
          PrefetchHooks Function()
        > {
  $$UnimorphFormsTableTableTableManager(
    _$AppDatabase db,
    $UnimorphFormsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UnimorphFormsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UnimorphFormsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UnimorphFormsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> wordId = const Value.absent(),
                Value<String> form = const Value.absent(),
                Value<String> unimorphTag = const Value.absent(),
                Value<String> labelFr = const Value.absent(),
                Value<bool> isIrregular = const Value.absent(),
              }) => UnimorphFormsTableCompanion(
                id: id,
                wordId: wordId,
                form: form,
                unimorphTag: unimorphTag,
                labelFr: labelFr,
                isIrregular: isIrregular,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int wordId,
                required String form,
                required String unimorphTag,
                required String labelFr,
                Value<bool> isIrregular = const Value.absent(),
              }) => UnimorphFormsTableCompanion.insert(
                id: id,
                wordId: wordId,
                form: form,
                unimorphTag: unimorphTag,
                labelFr: labelFr,
                isIrregular: isIrregular,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UnimorphFormsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UnimorphFormsTableTable,
      UnimorphFormEntry,
      $$UnimorphFormsTableTableFilterComposer,
      $$UnimorphFormsTableTableOrderingComposer,
      $$UnimorphFormsTableTableAnnotationComposer,
      $$UnimorphFormsTableTableCreateCompanionBuilder,
      $$UnimorphFormsTableTableUpdateCompanionBuilder,
      (
        UnimorphFormEntry,
        BaseReferences<
          _$AppDatabase,
          $UnimorphFormsTableTable,
          UnimorphFormEntry
        >,
      ),
      UnimorphFormEntry,
      PrefetchHooks Function()
    >;
typedef $$GrammarRulesTableTableCreateCompanionBuilder =
    GrammarRulesTableCompanion Function({
      Value<int> id,
      Value<String> language,
      required String ruleCode,
      required String title,
      required String level,
      required String explanationFr,
      required String formulaPattern,
    });
typedef $$GrammarRulesTableTableUpdateCompanionBuilder =
    GrammarRulesTableCompanion Function({
      Value<int> id,
      Value<String> language,
      Value<String> ruleCode,
      Value<String> title,
      Value<String> level,
      Value<String> explanationFr,
      Value<String> formulaPattern,
    });

class $$GrammarRulesTableTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarRulesTableTable> {
  $$GrammarRulesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ruleCode => $composableBuilder(
    column: $table.ruleCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get explanationFr => $composableBuilder(
    column: $table.explanationFr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formulaPattern => $composableBuilder(
    column: $table.formulaPattern,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GrammarRulesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarRulesTableTable> {
  $$GrammarRulesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ruleCode => $composableBuilder(
    column: $table.ruleCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get explanationFr => $composableBuilder(
    column: $table.explanationFr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formulaPattern => $composableBuilder(
    column: $table.formulaPattern,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrammarRulesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarRulesTableTable> {
  $$GrammarRulesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get ruleCode =>
      $composableBuilder(column: $table.ruleCode, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<String> get explanationFr => $composableBuilder(
    column: $table.explanationFr,
    builder: (column) => column,
  );

  GeneratedColumn<String> get formulaPattern => $composableBuilder(
    column: $table.formulaPattern,
    builder: (column) => column,
  );
}

class $$GrammarRulesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrammarRulesTableTable,
          GrammarRuleEntry,
          $$GrammarRulesTableTableFilterComposer,
          $$GrammarRulesTableTableOrderingComposer,
          $$GrammarRulesTableTableAnnotationComposer,
          $$GrammarRulesTableTableCreateCompanionBuilder,
          $$GrammarRulesTableTableUpdateCompanionBuilder,
          (
            GrammarRuleEntry,
            BaseReferences<
              _$AppDatabase,
              $GrammarRulesTableTable,
              GrammarRuleEntry
            >,
          ),
          GrammarRuleEntry,
          PrefetchHooks Function()
        > {
  $$GrammarRulesTableTableTableManager(
    _$AppDatabase db,
    $GrammarRulesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarRulesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarRulesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GrammarRulesTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> ruleCode = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<String> explanationFr = const Value.absent(),
                Value<String> formulaPattern = const Value.absent(),
              }) => GrammarRulesTableCompanion(
                id: id,
                language: language,
                ruleCode: ruleCode,
                title: title,
                level: level,
                explanationFr: explanationFr,
                formulaPattern: formulaPattern,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                required String ruleCode,
                required String title,
                required String level,
                required String explanationFr,
                required String formulaPattern,
              }) => GrammarRulesTableCompanion.insert(
                id: id,
                language: language,
                ruleCode: ruleCode,
                title: title,
                level: level,
                explanationFr: explanationFr,
                formulaPattern: formulaPattern,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GrammarRulesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrammarRulesTableTable,
      GrammarRuleEntry,
      $$GrammarRulesTableTableFilterComposer,
      $$GrammarRulesTableTableOrderingComposer,
      $$GrammarRulesTableTableAnnotationComposer,
      $$GrammarRulesTableTableCreateCompanionBuilder,
      $$GrammarRulesTableTableUpdateCompanionBuilder,
      (
        GrammarRuleEntry,
        BaseReferences<
          _$AppDatabase,
          $GrammarRulesTableTable,
          GrammarRuleEntry
        >,
      ),
      GrammarRuleEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableTableManager get wordsTable =>
      $$WordsTableTableTableManager(_db, _db.wordsTable);
  $$WordProgressTableTableTableManager get wordProgressTable =>
      $$WordProgressTableTableTableManager(_db, _db.wordProgressTable);
  $$UnimorphFormsTableTableTableManager get unimorphFormsTable =>
      $$UnimorphFormsTableTableTableManager(_db, _db.unimorphFormsTable);
  $$GrammarRulesTableTableTableManager get grammarRulesTable =>
      $$GrammarRulesTableTableTableManager(_db, _db.grammarRulesTable);
}
