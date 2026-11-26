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

class $LanguagesTableTable extends LanguagesTable
    with TableInfo<$LanguagesTableTable, LanguageEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LanguagesTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 2,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _nameL10nJsonMeta = const VerificationMeta(
    'nameL10nJson',
  );
  @override
  late final GeneratedColumn<String> nameL10nJson = GeneratedColumn<String>(
    'name_l10n_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isNonLatinMeta = const VerificationMeta(
    'isNonLatin',
  );
  @override
  late final GeneratedColumn<bool> isNonLatin = GeneratedColumn<bool>(
    'is_non_latin',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_non_latin" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _grammarProfileJsonMeta =
      const VerificationMeta('grammarProfileJson');
  @override
  late final GeneratedColumn<String> grammarProfileJson =
      GeneratedColumn<String>(
        'grammar_profile_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    code,
    nameL10nJson,
    isNonLatin,
    grammarProfileJson,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'languages_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LanguageEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('name_l10n_json')) {
      context.handle(
        _nameL10nJsonMeta,
        nameL10nJson.isAcceptableOrUnknown(
          data['name_l10n_json']!,
          _nameL10nJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nameL10nJsonMeta);
    }
    if (data.containsKey('is_non_latin')) {
      context.handle(
        _isNonLatinMeta,
        isNonLatin.isAcceptableOrUnknown(
          data['is_non_latin']!,
          _isNonLatinMeta,
        ),
      );
    }
    if (data.containsKey('grammar_profile_json')) {
      context.handle(
        _grammarProfileJsonMeta,
        grammarProfileJson.isAcceptableOrUnknown(
          data['grammar_profile_json']!,
          _grammarProfileJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_grammarProfileJsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LanguageEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LanguageEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      nameL10nJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name_l10n_json'],
      )!,
      isNonLatin: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_non_latin'],
      )!,
      grammarProfileJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}grammar_profile_json'],
      )!,
    );
  }

  @override
  $LanguagesTableTable createAlias(String alias) {
    return $LanguagesTableTable(attachedDatabase, alias);
  }
}

class LanguageEntry extends DataClass implements Insertable<LanguageEntry> {
  final int id;
  final String code;
  final String nameL10nJson;
  final bool isNonLatin;
  final String grammarProfileJson;
  const LanguageEntry({
    required this.id,
    required this.code,
    required this.nameL10nJson,
    required this.isNonLatin,
    required this.grammarProfileJson,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['code'] = Variable<String>(code);
    map['name_l10n_json'] = Variable<String>(nameL10nJson);
    map['is_non_latin'] = Variable<bool>(isNonLatin);
    map['grammar_profile_json'] = Variable<String>(grammarProfileJson);
    return map;
  }

  LanguagesTableCompanion toCompanion(bool nullToAbsent) {
    return LanguagesTableCompanion(
      id: Value(id),
      code: Value(code),
      nameL10nJson: Value(nameL10nJson),
      isNonLatin: Value(isNonLatin),
      grammarProfileJson: Value(grammarProfileJson),
    );
  }

  factory LanguageEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LanguageEntry(
      id: serializer.fromJson<int>(json['id']),
      code: serializer.fromJson<String>(json['code']),
      nameL10nJson: serializer.fromJson<String>(json['nameL10nJson']),
      isNonLatin: serializer.fromJson<bool>(json['isNonLatin']),
      grammarProfileJson: serializer.fromJson<String>(
        json['grammarProfileJson'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'code': serializer.toJson<String>(code),
      'nameL10nJson': serializer.toJson<String>(nameL10nJson),
      'isNonLatin': serializer.toJson<bool>(isNonLatin),
      'grammarProfileJson': serializer.toJson<String>(grammarProfileJson),
    };
  }

  LanguageEntry copyWith({
    int? id,
    String? code,
    String? nameL10nJson,
    bool? isNonLatin,
    String? grammarProfileJson,
  }) => LanguageEntry(
    id: id ?? this.id,
    code: code ?? this.code,
    nameL10nJson: nameL10nJson ?? this.nameL10nJson,
    isNonLatin: isNonLatin ?? this.isNonLatin,
    grammarProfileJson: grammarProfileJson ?? this.grammarProfileJson,
  );
  LanguageEntry copyWithCompanion(LanguagesTableCompanion data) {
    return LanguageEntry(
      id: data.id.present ? data.id.value : this.id,
      code: data.code.present ? data.code.value : this.code,
      nameL10nJson: data.nameL10nJson.present
          ? data.nameL10nJson.value
          : this.nameL10nJson,
      isNonLatin: data.isNonLatin.present
          ? data.isNonLatin.value
          : this.isNonLatin,
      grammarProfileJson: data.grammarProfileJson.present
          ? data.grammarProfileJson.value
          : this.grammarProfileJson,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LanguageEntry(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameL10nJson: $nameL10nJson, ')
          ..write('isNonLatin: $isNonLatin, ')
          ..write('grammarProfileJson: $grammarProfileJson')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, code, nameL10nJson, isNonLatin, grammarProfileJson);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LanguageEntry &&
          other.id == this.id &&
          other.code == this.code &&
          other.nameL10nJson == this.nameL10nJson &&
          other.isNonLatin == this.isNonLatin &&
          other.grammarProfileJson == this.grammarProfileJson);
}

class LanguagesTableCompanion extends UpdateCompanion<LanguageEntry> {
  final Value<int> id;
  final Value<String> code;
  final Value<String> nameL10nJson;
  final Value<bool> isNonLatin;
  final Value<String> grammarProfileJson;
  const LanguagesTableCompanion({
    this.id = const Value.absent(),
    this.code = const Value.absent(),
    this.nameL10nJson = const Value.absent(),
    this.isNonLatin = const Value.absent(),
    this.grammarProfileJson = const Value.absent(),
  });
  LanguagesTableCompanion.insert({
    this.id = const Value.absent(),
    required String code,
    required String nameL10nJson,
    this.isNonLatin = const Value.absent(),
    required String grammarProfileJson,
  }) : code = Value(code),
       nameL10nJson = Value(nameL10nJson),
       grammarProfileJson = Value(grammarProfileJson);
  static Insertable<LanguageEntry> custom({
    Expression<int>? id,
    Expression<String>? code,
    Expression<String>? nameL10nJson,
    Expression<bool>? isNonLatin,
    Expression<String>? grammarProfileJson,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (code != null) 'code': code,
      if (nameL10nJson != null) 'name_l10n_json': nameL10nJson,
      if (isNonLatin != null) 'is_non_latin': isNonLatin,
      if (grammarProfileJson != null)
        'grammar_profile_json': grammarProfileJson,
    });
  }

  LanguagesTableCompanion copyWith({
    Value<int>? id,
    Value<String>? code,
    Value<String>? nameL10nJson,
    Value<bool>? isNonLatin,
    Value<String>? grammarProfileJson,
  }) {
    return LanguagesTableCompanion(
      id: id ?? this.id,
      code: code ?? this.code,
      nameL10nJson: nameL10nJson ?? this.nameL10nJson,
      isNonLatin: isNonLatin ?? this.isNonLatin,
      grammarProfileJson: grammarProfileJson ?? this.grammarProfileJson,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (nameL10nJson.present) {
      map['name_l10n_json'] = Variable<String>(nameL10nJson.value);
    }
    if (isNonLatin.present) {
      map['is_non_latin'] = Variable<bool>(isNonLatin.value);
    }
    if (grammarProfileJson.present) {
      map['grammar_profile_json'] = Variable<String>(grammarProfileJson.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LanguagesTableCompanion(')
          ..write('id: $id, ')
          ..write('code: $code, ')
          ..write('nameL10nJson: $nameL10nJson, ')
          ..write('isNonLatin: $isNonLatin, ')
          ..write('grammarProfileJson: $grammarProfileJson')
          ..write(')'))
        .toString();
  }
}

class $ConjugationsTableTable extends ConjugationsTable
    with TableInfo<$ConjugationsTableTable, ConjugationEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ConjugationsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _langIdMeta = const VerificationMeta('langId');
  @override
  late final GeneratedColumn<int> langId = GeneratedColumn<int>(
    'lang_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
    'lemma',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _verbGroupMeta = const VerificationMeta(
    'verbGroup',
  );
  @override
  late final GeneratedColumn<String> verbGroup = GeneratedColumn<String>(
    'verb_group',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _auxiliariesJsonMeta = const VerificationMeta(
    'auxiliariesJson',
  );
  @override
  late final GeneratedColumn<String> auxiliariesJson = GeneratedColumn<String>(
    'auxiliaries_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isPronominalMeta = const VerificationMeta(
    'isPronominal',
  );
  @override
  late final GeneratedColumn<bool> isPronominal = GeneratedColumn<bool>(
    'is_pronominal',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pronominal" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _reflexiveCaseMeta = const VerificationMeta(
    'reflexiveCase',
  );
  @override
  late final GeneratedColumn<String> reflexiveCase = GeneratedColumn<String>(
    'reflexive_case',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _isDefectiveMeta = const VerificationMeta(
    'isDefective',
  );
  @override
  late final GeneratedColumn<bool> isDefective = GeneratedColumn<bool>(
    'is_defective',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_defective" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _generalNoteJsonMeta = const VerificationMeta(
    'generalNoteJson',
  );
  @override
  late final GeneratedColumn<String> generalNoteJson = GeneratedColumn<String>(
    'general_note_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _formsJsonMeta = const VerificationMeta(
    'formsJson',
  );
  @override
  late final GeneratedColumn<String> formsJson = GeneratedColumn<String>(
    'forms_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    langId,
    lemma,
    verbGroup,
    auxiliariesJson,
    isPronominal,
    reflexiveCase,
    isIrregular,
    isDefective,
    generalNoteJson,
    formsJson,
    source,
    isPublished,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'conjugations_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<ConjugationEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lang_id')) {
      context.handle(
        _langIdMeta,
        langId.isAcceptableOrUnknown(data['lang_id']!, _langIdMeta),
      );
    } else if (isInserting) {
      context.missing(_langIdMeta);
    }
    if (data.containsKey('lemma')) {
      context.handle(
        _lemmaMeta,
        lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaMeta);
    }
    if (data.containsKey('verb_group')) {
      context.handle(
        _verbGroupMeta,
        verbGroup.isAcceptableOrUnknown(data['verb_group']!, _verbGroupMeta),
      );
    }
    if (data.containsKey('auxiliaries_json')) {
      context.handle(
        _auxiliariesJsonMeta,
        auxiliariesJson.isAcceptableOrUnknown(
          data['auxiliaries_json']!,
          _auxiliariesJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_pronominal')) {
      context.handle(
        _isPronominalMeta,
        isPronominal.isAcceptableOrUnknown(
          data['is_pronominal']!,
          _isPronominalMeta,
        ),
      );
    }
    if (data.containsKey('reflexive_case')) {
      context.handle(
        _reflexiveCaseMeta,
        reflexiveCase.isAcceptableOrUnknown(
          data['reflexive_case']!,
          _reflexiveCaseMeta,
        ),
      );
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
    if (data.containsKey('is_defective')) {
      context.handle(
        _isDefectiveMeta,
        isDefective.isAcceptableOrUnknown(
          data['is_defective']!,
          _isDefectiveMeta,
        ),
      );
    }
    if (data.containsKey('general_note_json')) {
      context.handle(
        _generalNoteJsonMeta,
        generalNoteJson.isAcceptableOrUnknown(
          data['general_note_json']!,
          _generalNoteJsonMeta,
        ),
      );
    }
    if (data.containsKey('forms_json')) {
      context.handle(
        _formsJsonMeta,
        formsJson.isAcceptableOrUnknown(data['forms_json']!, _formsJsonMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {langId, lemma},
  ];
  @override
  ConjugationEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ConjugationEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      langId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lang_id'],
      )!,
      lemma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lemma'],
      )!,
      verbGroup: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}verb_group'],
      ),
      auxiliariesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}auxiliaries_json'],
      )!,
      isPronominal: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pronominal'],
      )!,
      reflexiveCase: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reflexive_case'],
      ),
      isIrregular: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_irregular'],
      )!,
      isDefective: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_defective'],
      )!,
      generalNoteJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}general_note_json'],
      )!,
      formsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}forms_json'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
    );
  }

  @override
  $ConjugationsTableTable createAlias(String alias) {
    return $ConjugationsTableTable(attachedDatabase, alias);
  }
}

class ConjugationEntry extends DataClass
    implements Insertable<ConjugationEntry> {
  final int id;
  final int langId;
  final String lemma;
  final String? verbGroup;
  final String auxiliariesJson;
  final bool isPronominal;
  final String? reflexiveCase;
  final bool isIrregular;
  final bool isDefective;
  final String generalNoteJson;
  final String formsJson;
  final String source;
  final bool isPublished;
  const ConjugationEntry({
    required this.id,
    required this.langId,
    required this.lemma,
    this.verbGroup,
    required this.auxiliariesJson,
    required this.isPronominal,
    this.reflexiveCase,
    required this.isIrregular,
    required this.isDefective,
    required this.generalNoteJson,
    required this.formsJson,
    required this.source,
    required this.isPublished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lang_id'] = Variable<int>(langId);
    map['lemma'] = Variable<String>(lemma);
    if (!nullToAbsent || verbGroup != null) {
      map['verb_group'] = Variable<String>(verbGroup);
    }
    map['auxiliaries_json'] = Variable<String>(auxiliariesJson);
    map['is_pronominal'] = Variable<bool>(isPronominal);
    if (!nullToAbsent || reflexiveCase != null) {
      map['reflexive_case'] = Variable<String>(reflexiveCase);
    }
    map['is_irregular'] = Variable<bool>(isIrregular);
    map['is_defective'] = Variable<bool>(isDefective);
    map['general_note_json'] = Variable<String>(generalNoteJson);
    map['forms_json'] = Variable<String>(formsJson);
    map['source'] = Variable<String>(source);
    map['is_published'] = Variable<bool>(isPublished);
    return map;
  }

  ConjugationsTableCompanion toCompanion(bool nullToAbsent) {
    return ConjugationsTableCompanion(
      id: Value(id),
      langId: Value(langId),
      lemma: Value(lemma),
      verbGroup: verbGroup == null && nullToAbsent
          ? const Value.absent()
          : Value(verbGroup),
      auxiliariesJson: Value(auxiliariesJson),
      isPronominal: Value(isPronominal),
      reflexiveCase: reflexiveCase == null && nullToAbsent
          ? const Value.absent()
          : Value(reflexiveCase),
      isIrregular: Value(isIrregular),
      isDefective: Value(isDefective),
      generalNoteJson: Value(generalNoteJson),
      formsJson: Value(formsJson),
      source: Value(source),
      isPublished: Value(isPublished),
    );
  }

  factory ConjugationEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ConjugationEntry(
      id: serializer.fromJson<int>(json['id']),
      langId: serializer.fromJson<int>(json['langId']),
      lemma: serializer.fromJson<String>(json['lemma']),
      verbGroup: serializer.fromJson<String?>(json['verbGroup']),
      auxiliariesJson: serializer.fromJson<String>(json['auxiliariesJson']),
      isPronominal: serializer.fromJson<bool>(json['isPronominal']),
      reflexiveCase: serializer.fromJson<String?>(json['reflexiveCase']),
      isIrregular: serializer.fromJson<bool>(json['isIrregular']),
      isDefective: serializer.fromJson<bool>(json['isDefective']),
      generalNoteJson: serializer.fromJson<String>(json['generalNoteJson']),
      formsJson: serializer.fromJson<String>(json['formsJson']),
      source: serializer.fromJson<String>(json['source']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'langId': serializer.toJson<int>(langId),
      'lemma': serializer.toJson<String>(lemma),
      'verbGroup': serializer.toJson<String?>(verbGroup),
      'auxiliariesJson': serializer.toJson<String>(auxiliariesJson),
      'isPronominal': serializer.toJson<bool>(isPronominal),
      'reflexiveCase': serializer.toJson<String?>(reflexiveCase),
      'isIrregular': serializer.toJson<bool>(isIrregular),
      'isDefective': serializer.toJson<bool>(isDefective),
      'generalNoteJson': serializer.toJson<String>(generalNoteJson),
      'formsJson': serializer.toJson<String>(formsJson),
      'source': serializer.toJson<String>(source),
      'isPublished': serializer.toJson<bool>(isPublished),
    };
  }

  ConjugationEntry copyWith({
    int? id,
    int? langId,
    String? lemma,
    Value<String?> verbGroup = const Value.absent(),
    String? auxiliariesJson,
    bool? isPronominal,
    Value<String?> reflexiveCase = const Value.absent(),
    bool? isIrregular,
    bool? isDefective,
    String? generalNoteJson,
    String? formsJson,
    String? source,
    bool? isPublished,
  }) => ConjugationEntry(
    id: id ?? this.id,
    langId: langId ?? this.langId,
    lemma: lemma ?? this.lemma,
    verbGroup: verbGroup.present ? verbGroup.value : this.verbGroup,
    auxiliariesJson: auxiliariesJson ?? this.auxiliariesJson,
    isPronominal: isPronominal ?? this.isPronominal,
    reflexiveCase: reflexiveCase.present
        ? reflexiveCase.value
        : this.reflexiveCase,
    isIrregular: isIrregular ?? this.isIrregular,
    isDefective: isDefective ?? this.isDefective,
    generalNoteJson: generalNoteJson ?? this.generalNoteJson,
    formsJson: formsJson ?? this.formsJson,
    source: source ?? this.source,
    isPublished: isPublished ?? this.isPublished,
  );
  ConjugationEntry copyWithCompanion(ConjugationsTableCompanion data) {
    return ConjugationEntry(
      id: data.id.present ? data.id.value : this.id,
      langId: data.langId.present ? data.langId.value : this.langId,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
      verbGroup: data.verbGroup.present ? data.verbGroup.value : this.verbGroup,
      auxiliariesJson: data.auxiliariesJson.present
          ? data.auxiliariesJson.value
          : this.auxiliariesJson,
      isPronominal: data.isPronominal.present
          ? data.isPronominal.value
          : this.isPronominal,
      reflexiveCase: data.reflexiveCase.present
          ? data.reflexiveCase.value
          : this.reflexiveCase,
      isIrregular: data.isIrregular.present
          ? data.isIrregular.value
          : this.isIrregular,
      isDefective: data.isDefective.present
          ? data.isDefective.value
          : this.isDefective,
      generalNoteJson: data.generalNoteJson.present
          ? data.generalNoteJson.value
          : this.generalNoteJson,
      formsJson: data.formsJson.present ? data.formsJson.value : this.formsJson,
      source: data.source.present ? data.source.value : this.source,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ConjugationEntry(')
          ..write('id: $id, ')
          ..write('langId: $langId, ')
          ..write('lemma: $lemma, ')
          ..write('verbGroup: $verbGroup, ')
          ..write('auxiliariesJson: $auxiliariesJson, ')
          ..write('isPronominal: $isPronominal, ')
          ..write('reflexiveCase: $reflexiveCase, ')
          ..write('isIrregular: $isIrregular, ')
          ..write('isDefective: $isDefective, ')
          ..write('generalNoteJson: $generalNoteJson, ')
          ..write('formsJson: $formsJson, ')
          ..write('source: $source, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    langId,
    lemma,
    verbGroup,
    auxiliariesJson,
    isPronominal,
    reflexiveCase,
    isIrregular,
    isDefective,
    generalNoteJson,
    formsJson,
    source,
    isPublished,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ConjugationEntry &&
          other.id == this.id &&
          other.langId == this.langId &&
          other.lemma == this.lemma &&
          other.verbGroup == this.verbGroup &&
          other.auxiliariesJson == this.auxiliariesJson &&
          other.isPronominal == this.isPronominal &&
          other.reflexiveCase == this.reflexiveCase &&
          other.isIrregular == this.isIrregular &&
          other.isDefective == this.isDefective &&
          other.generalNoteJson == this.generalNoteJson &&
          other.formsJson == this.formsJson &&
          other.source == this.source &&
          other.isPublished == this.isPublished);
}

class ConjugationsTableCompanion extends UpdateCompanion<ConjugationEntry> {
  final Value<int> id;
  final Value<int> langId;
  final Value<String> lemma;
  final Value<String?> verbGroup;
  final Value<String> auxiliariesJson;
  final Value<bool> isPronominal;
  final Value<String?> reflexiveCase;
  final Value<bool> isIrregular;
  final Value<bool> isDefective;
  final Value<String> generalNoteJson;
  final Value<String> formsJson;
  final Value<String> source;
  final Value<bool> isPublished;
  const ConjugationsTableCompanion({
    this.id = const Value.absent(),
    this.langId = const Value.absent(),
    this.lemma = const Value.absent(),
    this.verbGroup = const Value.absent(),
    this.auxiliariesJson = const Value.absent(),
    this.isPronominal = const Value.absent(),
    this.reflexiveCase = const Value.absent(),
    this.isIrregular = const Value.absent(),
    this.isDefective = const Value.absent(),
    this.generalNoteJson = const Value.absent(),
    this.formsJson = const Value.absent(),
    this.source = const Value.absent(),
    this.isPublished = const Value.absent(),
  });
  ConjugationsTableCompanion.insert({
    this.id = const Value.absent(),
    required int langId,
    required String lemma,
    this.verbGroup = const Value.absent(),
    this.auxiliariesJson = const Value.absent(),
    this.isPronominal = const Value.absent(),
    this.reflexiveCase = const Value.absent(),
    this.isIrregular = const Value.absent(),
    this.isDefective = const Value.absent(),
    this.generalNoteJson = const Value.absent(),
    this.formsJson = const Value.absent(),
    this.source = const Value.absent(),
    this.isPublished = const Value.absent(),
  }) : langId = Value(langId),
       lemma = Value(lemma);
  static Insertable<ConjugationEntry> custom({
    Expression<int>? id,
    Expression<int>? langId,
    Expression<String>? lemma,
    Expression<String>? verbGroup,
    Expression<String>? auxiliariesJson,
    Expression<bool>? isPronominal,
    Expression<String>? reflexiveCase,
    Expression<bool>? isIrregular,
    Expression<bool>? isDefective,
    Expression<String>? generalNoteJson,
    Expression<String>? formsJson,
    Expression<String>? source,
    Expression<bool>? isPublished,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (langId != null) 'lang_id': langId,
      if (lemma != null) 'lemma': lemma,
      if (verbGroup != null) 'verb_group': verbGroup,
      if (auxiliariesJson != null) 'auxiliaries_json': auxiliariesJson,
      if (isPronominal != null) 'is_pronominal': isPronominal,
      if (reflexiveCase != null) 'reflexive_case': reflexiveCase,
      if (isIrregular != null) 'is_irregular': isIrregular,
      if (isDefective != null) 'is_defective': isDefective,
      if (generalNoteJson != null) 'general_note_json': generalNoteJson,
      if (formsJson != null) 'forms_json': formsJson,
      if (source != null) 'source': source,
      if (isPublished != null) 'is_published': isPublished,
    });
  }

  ConjugationsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? langId,
    Value<String>? lemma,
    Value<String?>? verbGroup,
    Value<String>? auxiliariesJson,
    Value<bool>? isPronominal,
    Value<String?>? reflexiveCase,
    Value<bool>? isIrregular,
    Value<bool>? isDefective,
    Value<String>? generalNoteJson,
    Value<String>? formsJson,
    Value<String>? source,
    Value<bool>? isPublished,
  }) {
    return ConjugationsTableCompanion(
      id: id ?? this.id,
      langId: langId ?? this.langId,
      lemma: lemma ?? this.lemma,
      verbGroup: verbGroup ?? this.verbGroup,
      auxiliariesJson: auxiliariesJson ?? this.auxiliariesJson,
      isPronominal: isPronominal ?? this.isPronominal,
      reflexiveCase: reflexiveCase ?? this.reflexiveCase,
      isIrregular: isIrregular ?? this.isIrregular,
      isDefective: isDefective ?? this.isDefective,
      generalNoteJson: generalNoteJson ?? this.generalNoteJson,
      formsJson: formsJson ?? this.formsJson,
      source: source ?? this.source,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (langId.present) {
      map['lang_id'] = Variable<int>(langId.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    if (verbGroup.present) {
      map['verb_group'] = Variable<String>(verbGroup.value);
    }
    if (auxiliariesJson.present) {
      map['auxiliaries_json'] = Variable<String>(auxiliariesJson.value);
    }
    if (isPronominal.present) {
      map['is_pronominal'] = Variable<bool>(isPronominal.value);
    }
    if (reflexiveCase.present) {
      map['reflexive_case'] = Variable<String>(reflexiveCase.value);
    }
    if (isIrregular.present) {
      map['is_irregular'] = Variable<bool>(isIrregular.value);
    }
    if (isDefective.present) {
      map['is_defective'] = Variable<bool>(isDefective.value);
    }
    if (generalNoteJson.present) {
      map['general_note_json'] = Variable<String>(generalNoteJson.value);
    }
    if (formsJson.present) {
      map['forms_json'] = Variable<String>(formsJson.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ConjugationsTableCompanion(')
          ..write('id: $id, ')
          ..write('langId: $langId, ')
          ..write('lemma: $lemma, ')
          ..write('verbGroup: $verbGroup, ')
          ..write('auxiliariesJson: $auxiliariesJson, ')
          ..write('isPronominal: $isPronominal, ')
          ..write('reflexiveCase: $reflexiveCase, ')
          ..write('isIrregular: $isIrregular, ')
          ..write('isDefective: $isDefective, ')
          ..write('generalNoteJson: $generalNoteJson, ')
          ..write('formsJson: $formsJson, ')
          ..write('source: $source, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }
}

class $DeclensionsTableTable extends DeclensionsTable
    with TableInfo<$DeclensionsTableTable, DeclensionEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeclensionsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _langIdMeta = const VerificationMeta('langId');
  @override
  late final GeneratedColumn<int> langId = GeneratedColumn<int>(
    'lang_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lemmaMeta = const VerificationMeta('lemma');
  @override
  late final GeneratedColumn<String> lemma = GeneratedColumn<String>(
    'lemma',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 150,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 3,
      maxTextLength: 10,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _genderMeta = const VerificationMeta('gender');
  @override
  late final GeneratedColumn<String> gender = GeneratedColumn<String>(
    'gender',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _declensionClassMeta = const VerificationMeta(
    'declensionClass',
  );
  @override
  late final GeneratedColumn<String> declensionClass = GeneratedColumn<String>(
    'declension_class',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
  static const VerificationMeta _isInvariableMeta = const VerificationMeta(
    'isInvariable',
  );
  @override
  late final GeneratedColumn<bool> isInvariable = GeneratedColumn<bool>(
    'is_invariable',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_invariable" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _generalNoteJsonMeta = const VerificationMeta(
    'generalNoteJson',
  );
  @override
  late final GeneratedColumn<String> generalNoteJson = GeneratedColumn<String>(
    'general_note_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _formsJsonMeta = const VerificationMeta(
    'formsJson',
  );
  @override
  late final GeneratedColumn<String> formsJson = GeneratedColumn<String>(
    'forms_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
    'source',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('manual'),
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    langId,
    lemma,
    pos,
    gender,
    declensionClass,
    isIrregular,
    isInvariable,
    generalNoteJson,
    formsJson,
    source,
    isPublished,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'declensions_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeclensionEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lang_id')) {
      context.handle(
        _langIdMeta,
        langId.isAcceptableOrUnknown(data['lang_id']!, _langIdMeta),
      );
    } else if (isInserting) {
      context.missing(_langIdMeta);
    }
    if (data.containsKey('lemma')) {
      context.handle(
        _lemmaMeta,
        lemma.isAcceptableOrUnknown(data['lemma']!, _lemmaMeta),
      );
    } else if (isInserting) {
      context.missing(_lemmaMeta);
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    } else if (isInserting) {
      context.missing(_posMeta);
    }
    if (data.containsKey('gender')) {
      context.handle(
        _genderMeta,
        gender.isAcceptableOrUnknown(data['gender']!, _genderMeta),
      );
    }
    if (data.containsKey('declension_class')) {
      context.handle(
        _declensionClassMeta,
        declensionClass.isAcceptableOrUnknown(
          data['declension_class']!,
          _declensionClassMeta,
        ),
      );
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
    if (data.containsKey('is_invariable')) {
      context.handle(
        _isInvariableMeta,
        isInvariable.isAcceptableOrUnknown(
          data['is_invariable']!,
          _isInvariableMeta,
        ),
      );
    }
    if (data.containsKey('general_note_json')) {
      context.handle(
        _generalNoteJsonMeta,
        generalNoteJson.isAcceptableOrUnknown(
          data['general_note_json']!,
          _generalNoteJsonMeta,
        ),
      );
    }
    if (data.containsKey('forms_json')) {
      context.handle(
        _formsJsonMeta,
        formsJson.isAcceptableOrUnknown(data['forms_json']!, _formsJsonMeta),
      );
    }
    if (data.containsKey('source')) {
      context.handle(
        _sourceMeta,
        source.isAcceptableOrUnknown(data['source']!, _sourceMeta),
      );
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {langId, lemma, pos},
  ];
  @override
  DeclensionEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeclensionEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      langId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lang_id'],
      )!,
      lemma: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lemma'],
      )!,
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      )!,
      gender: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gender'],
      ),
      declensionClass: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}declension_class'],
      ),
      isIrregular: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_irregular'],
      )!,
      isInvariable: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_invariable'],
      )!,
      generalNoteJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}general_note_json'],
      )!,
      formsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}forms_json'],
      )!,
      source: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source'],
      )!,
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
    );
  }

  @override
  $DeclensionsTableTable createAlias(String alias) {
    return $DeclensionsTableTable(attachedDatabase, alias);
  }
}

class DeclensionEntry extends DataClass implements Insertable<DeclensionEntry> {
  final int id;
  final int langId;
  final String lemma;
  final String pos;
  final String? gender;
  final String? declensionClass;
  final bool isIrregular;
  final bool isInvariable;
  final String generalNoteJson;
  final String formsJson;
  final String source;
  final bool isPublished;
  const DeclensionEntry({
    required this.id,
    required this.langId,
    required this.lemma,
    required this.pos,
    this.gender,
    this.declensionClass,
    required this.isIrregular,
    required this.isInvariable,
    required this.generalNoteJson,
    required this.formsJson,
    required this.source,
    required this.isPublished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lang_id'] = Variable<int>(langId);
    map['lemma'] = Variable<String>(lemma);
    map['pos'] = Variable<String>(pos);
    if (!nullToAbsent || gender != null) {
      map['gender'] = Variable<String>(gender);
    }
    if (!nullToAbsent || declensionClass != null) {
      map['declension_class'] = Variable<String>(declensionClass);
    }
    map['is_irregular'] = Variable<bool>(isIrregular);
    map['is_invariable'] = Variable<bool>(isInvariable);
    map['general_note_json'] = Variable<String>(generalNoteJson);
    map['forms_json'] = Variable<String>(formsJson);
    map['source'] = Variable<String>(source);
    map['is_published'] = Variable<bool>(isPublished);
    return map;
  }

  DeclensionsTableCompanion toCompanion(bool nullToAbsent) {
    return DeclensionsTableCompanion(
      id: Value(id),
      langId: Value(langId),
      lemma: Value(lemma),
      pos: Value(pos),
      gender: gender == null && nullToAbsent
          ? const Value.absent()
          : Value(gender),
      declensionClass: declensionClass == null && nullToAbsent
          ? const Value.absent()
          : Value(declensionClass),
      isIrregular: Value(isIrregular),
      isInvariable: Value(isInvariable),
      generalNoteJson: Value(generalNoteJson),
      formsJson: Value(formsJson),
      source: Value(source),
      isPublished: Value(isPublished),
    );
  }

  factory DeclensionEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeclensionEntry(
      id: serializer.fromJson<int>(json['id']),
      langId: serializer.fromJson<int>(json['langId']),
      lemma: serializer.fromJson<String>(json['lemma']),
      pos: serializer.fromJson<String>(json['pos']),
      gender: serializer.fromJson<String?>(json['gender']),
      declensionClass: serializer.fromJson<String?>(json['declensionClass']),
      isIrregular: serializer.fromJson<bool>(json['isIrregular']),
      isInvariable: serializer.fromJson<bool>(json['isInvariable']),
      generalNoteJson: serializer.fromJson<String>(json['generalNoteJson']),
      formsJson: serializer.fromJson<String>(json['formsJson']),
      source: serializer.fromJson<String>(json['source']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'langId': serializer.toJson<int>(langId),
      'lemma': serializer.toJson<String>(lemma),
      'pos': serializer.toJson<String>(pos),
      'gender': serializer.toJson<String?>(gender),
      'declensionClass': serializer.toJson<String?>(declensionClass),
      'isIrregular': serializer.toJson<bool>(isIrregular),
      'isInvariable': serializer.toJson<bool>(isInvariable),
      'generalNoteJson': serializer.toJson<String>(generalNoteJson),
      'formsJson': serializer.toJson<String>(formsJson),
      'source': serializer.toJson<String>(source),
      'isPublished': serializer.toJson<bool>(isPublished),
    };
  }

  DeclensionEntry copyWith({
    int? id,
    int? langId,
    String? lemma,
    String? pos,
    Value<String?> gender = const Value.absent(),
    Value<String?> declensionClass = const Value.absent(),
    bool? isIrregular,
    bool? isInvariable,
    String? generalNoteJson,
    String? formsJson,
    String? source,
    bool? isPublished,
  }) => DeclensionEntry(
    id: id ?? this.id,
    langId: langId ?? this.langId,
    lemma: lemma ?? this.lemma,
    pos: pos ?? this.pos,
    gender: gender.present ? gender.value : this.gender,
    declensionClass: declensionClass.present
        ? declensionClass.value
        : this.declensionClass,
    isIrregular: isIrregular ?? this.isIrregular,
    isInvariable: isInvariable ?? this.isInvariable,
    generalNoteJson: generalNoteJson ?? this.generalNoteJson,
    formsJson: formsJson ?? this.formsJson,
    source: source ?? this.source,
    isPublished: isPublished ?? this.isPublished,
  );
  DeclensionEntry copyWithCompanion(DeclensionsTableCompanion data) {
    return DeclensionEntry(
      id: data.id.present ? data.id.value : this.id,
      langId: data.langId.present ? data.langId.value : this.langId,
      lemma: data.lemma.present ? data.lemma.value : this.lemma,
      pos: data.pos.present ? data.pos.value : this.pos,
      gender: data.gender.present ? data.gender.value : this.gender,
      declensionClass: data.declensionClass.present
          ? data.declensionClass.value
          : this.declensionClass,
      isIrregular: data.isIrregular.present
          ? data.isIrregular.value
          : this.isIrregular,
      isInvariable: data.isInvariable.present
          ? data.isInvariable.value
          : this.isInvariable,
      generalNoteJson: data.generalNoteJson.present
          ? data.generalNoteJson.value
          : this.generalNoteJson,
      formsJson: data.formsJson.present ? data.formsJson.value : this.formsJson,
      source: data.source.present ? data.source.value : this.source,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeclensionEntry(')
          ..write('id: $id, ')
          ..write('langId: $langId, ')
          ..write('lemma: $lemma, ')
          ..write('pos: $pos, ')
          ..write('gender: $gender, ')
          ..write('declensionClass: $declensionClass, ')
          ..write('isIrregular: $isIrregular, ')
          ..write('isInvariable: $isInvariable, ')
          ..write('generalNoteJson: $generalNoteJson, ')
          ..write('formsJson: $formsJson, ')
          ..write('source: $source, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    langId,
    lemma,
    pos,
    gender,
    declensionClass,
    isIrregular,
    isInvariable,
    generalNoteJson,
    formsJson,
    source,
    isPublished,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeclensionEntry &&
          other.id == this.id &&
          other.langId == this.langId &&
          other.lemma == this.lemma &&
          other.pos == this.pos &&
          other.gender == this.gender &&
          other.declensionClass == this.declensionClass &&
          other.isIrregular == this.isIrregular &&
          other.isInvariable == this.isInvariable &&
          other.generalNoteJson == this.generalNoteJson &&
          other.formsJson == this.formsJson &&
          other.source == this.source &&
          other.isPublished == this.isPublished);
}

class DeclensionsTableCompanion extends UpdateCompanion<DeclensionEntry> {
  final Value<int> id;
  final Value<int> langId;
  final Value<String> lemma;
  final Value<String> pos;
  final Value<String?> gender;
  final Value<String?> declensionClass;
  final Value<bool> isIrregular;
  final Value<bool> isInvariable;
  final Value<String> generalNoteJson;
  final Value<String> formsJson;
  final Value<String> source;
  final Value<bool> isPublished;
  const DeclensionsTableCompanion({
    this.id = const Value.absent(),
    this.langId = const Value.absent(),
    this.lemma = const Value.absent(),
    this.pos = const Value.absent(),
    this.gender = const Value.absent(),
    this.declensionClass = const Value.absent(),
    this.isIrregular = const Value.absent(),
    this.isInvariable = const Value.absent(),
    this.generalNoteJson = const Value.absent(),
    this.formsJson = const Value.absent(),
    this.source = const Value.absent(),
    this.isPublished = const Value.absent(),
  });
  DeclensionsTableCompanion.insert({
    this.id = const Value.absent(),
    required int langId,
    required String lemma,
    required String pos,
    this.gender = const Value.absent(),
    this.declensionClass = const Value.absent(),
    this.isIrregular = const Value.absent(),
    this.isInvariable = const Value.absent(),
    this.generalNoteJson = const Value.absent(),
    this.formsJson = const Value.absent(),
    this.source = const Value.absent(),
    this.isPublished = const Value.absent(),
  }) : langId = Value(langId),
       lemma = Value(lemma),
       pos = Value(pos);
  static Insertable<DeclensionEntry> custom({
    Expression<int>? id,
    Expression<int>? langId,
    Expression<String>? lemma,
    Expression<String>? pos,
    Expression<String>? gender,
    Expression<String>? declensionClass,
    Expression<bool>? isIrregular,
    Expression<bool>? isInvariable,
    Expression<String>? generalNoteJson,
    Expression<String>? formsJson,
    Expression<String>? source,
    Expression<bool>? isPublished,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (langId != null) 'lang_id': langId,
      if (lemma != null) 'lemma': lemma,
      if (pos != null) 'pos': pos,
      if (gender != null) 'gender': gender,
      if (declensionClass != null) 'declension_class': declensionClass,
      if (isIrregular != null) 'is_irregular': isIrregular,
      if (isInvariable != null) 'is_invariable': isInvariable,
      if (generalNoteJson != null) 'general_note_json': generalNoteJson,
      if (formsJson != null) 'forms_json': formsJson,
      if (source != null) 'source': source,
      if (isPublished != null) 'is_published': isPublished,
    });
  }

  DeclensionsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? langId,
    Value<String>? lemma,
    Value<String>? pos,
    Value<String?>? gender,
    Value<String?>? declensionClass,
    Value<bool>? isIrregular,
    Value<bool>? isInvariable,
    Value<String>? generalNoteJson,
    Value<String>? formsJson,
    Value<String>? source,
    Value<bool>? isPublished,
  }) {
    return DeclensionsTableCompanion(
      id: id ?? this.id,
      langId: langId ?? this.langId,
      lemma: lemma ?? this.lemma,
      pos: pos ?? this.pos,
      gender: gender ?? this.gender,
      declensionClass: declensionClass ?? this.declensionClass,
      isIrregular: isIrregular ?? this.isIrregular,
      isInvariable: isInvariable ?? this.isInvariable,
      generalNoteJson: generalNoteJson ?? this.generalNoteJson,
      formsJson: formsJson ?? this.formsJson,
      source: source ?? this.source,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (langId.present) {
      map['lang_id'] = Variable<int>(langId.value);
    }
    if (lemma.present) {
      map['lemma'] = Variable<String>(lemma.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (gender.present) {
      map['gender'] = Variable<String>(gender.value);
    }
    if (declensionClass.present) {
      map['declension_class'] = Variable<String>(declensionClass.value);
    }
    if (isIrregular.present) {
      map['is_irregular'] = Variable<bool>(isIrregular.value);
    }
    if (isInvariable.present) {
      map['is_invariable'] = Variable<bool>(isInvariable.value);
    }
    if (generalNoteJson.present) {
      map['general_note_json'] = Variable<String>(generalNoteJson.value);
    }
    if (formsJson.present) {
      map['forms_json'] = Variable<String>(formsJson.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeclensionsTableCompanion(')
          ..write('id: $id, ')
          ..write('langId: $langId, ')
          ..write('lemma: $lemma, ')
          ..write('pos: $pos, ')
          ..write('gender: $gender, ')
          ..write('declensionClass: $declensionClass, ')
          ..write('isIrregular: $isIrregular, ')
          ..write('isInvariable: $isInvariable, ')
          ..write('generalNoteJson: $generalNoteJson, ')
          ..write('formsJson: $formsJson, ')
          ..write('source: $source, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }
}

class $GrammarLessonsTableTable extends GrammarLessonsTable
    with TableInfo<$GrammarLessonsTableTable, GrammarLessonEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GrammarLessonsTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _langIdMeta = const VerificationMeta('langId');
  @override
  late final GeneratedColumn<int> langId = GeneratedColumn<int>(
    'lang_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
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
      maxTextLength: 4,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _orderIndexMeta = const VerificationMeta(
    'orderIndex',
  );
  @override
  late final GeneratedColumn<int> orderIndex = GeneratedColumn<int>(
    'order_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _titleJsonMeta = const VerificationMeta(
    'titleJson',
  );
  @override
  late final GeneratedColumn<String> titleJson = GeneratedColumn<String>(
    'title_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('{}'),
  );
  static const VerificationMeta _prerequisiteIdsJsonMeta =
      const VerificationMeta('prerequisiteIdsJson');
  @override
  late final GeneratedColumn<String> prerequisiteIdsJson =
      GeneratedColumn<String>(
        'prerequisite_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _linkedVerbIdsJsonMeta = const VerificationMeta(
    'linkedVerbIdsJson',
  );
  @override
  late final GeneratedColumn<String> linkedVerbIdsJson =
      GeneratedColumn<String>(
        'linked_verb_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _targetTensesJsonMeta = const VerificationMeta(
    'targetTensesJson',
  );
  @override
  late final GeneratedColumn<String> targetTensesJson = GeneratedColumn<String>(
    'target_tenses_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _linkedDeclensionIdsJsonMeta =
      const VerificationMeta('linkedDeclensionIdsJson');
  @override
  late final GeneratedColumn<String> linkedDeclensionIdsJson =
      GeneratedColumn<String>(
        'linked_declension_ids_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('[]'),
      );
  static const VerificationMeta _targetCasesJsonMeta = const VerificationMeta(
    'targetCasesJson',
  );
  @override
  late final GeneratedColumn<String> targetCasesJson = GeneratedColumn<String>(
    'target_cases_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _blocksJsonMeta = const VerificationMeta(
    'blocksJson',
  );
  @override
  late final GeneratedColumn<String> blocksJson = GeneratedColumn<String>(
    'blocks_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _exercisesJsonMeta = const VerificationMeta(
    'exercisesJson',
  );
  @override
  late final GeneratedColumn<String> exercisesJson = GeneratedColumn<String>(
    'exercises_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isPublishedMeta = const VerificationMeta(
    'isPublished',
  );
  @override
  late final GeneratedColumn<bool> isPublished = GeneratedColumn<bool>(
    'is_published',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_published" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    langId,
    slug,
    level,
    orderIndex,
    titleJson,
    prerequisiteIdsJson,
    linkedVerbIdsJson,
    targetTensesJson,
    linkedDeclensionIdsJson,
    targetCasesJson,
    blocksJson,
    exercisesJson,
    isPublished,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'grammar_lessons_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<GrammarLessonEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('lang_id')) {
      context.handle(
        _langIdMeta,
        langId.isAcceptableOrUnknown(data['lang_id']!, _langIdMeta),
      );
    } else if (isInserting) {
      context.missing(_langIdMeta);
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('order_index')) {
      context.handle(
        _orderIndexMeta,
        orderIndex.isAcceptableOrUnknown(data['order_index']!, _orderIndexMeta),
      );
    }
    if (data.containsKey('title_json')) {
      context.handle(
        _titleJsonMeta,
        titleJson.isAcceptableOrUnknown(data['title_json']!, _titleJsonMeta),
      );
    }
    if (data.containsKey('prerequisite_ids_json')) {
      context.handle(
        _prerequisiteIdsJsonMeta,
        prerequisiteIdsJson.isAcceptableOrUnknown(
          data['prerequisite_ids_json']!,
          _prerequisiteIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('linked_verb_ids_json')) {
      context.handle(
        _linkedVerbIdsJsonMeta,
        linkedVerbIdsJson.isAcceptableOrUnknown(
          data['linked_verb_ids_json']!,
          _linkedVerbIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('target_tenses_json')) {
      context.handle(
        _targetTensesJsonMeta,
        targetTensesJson.isAcceptableOrUnknown(
          data['target_tenses_json']!,
          _targetTensesJsonMeta,
        ),
      );
    }
    if (data.containsKey('linked_declension_ids_json')) {
      context.handle(
        _linkedDeclensionIdsJsonMeta,
        linkedDeclensionIdsJson.isAcceptableOrUnknown(
          data['linked_declension_ids_json']!,
          _linkedDeclensionIdsJsonMeta,
        ),
      );
    }
    if (data.containsKey('target_cases_json')) {
      context.handle(
        _targetCasesJsonMeta,
        targetCasesJson.isAcceptableOrUnknown(
          data['target_cases_json']!,
          _targetCasesJsonMeta,
        ),
      );
    }
    if (data.containsKey('blocks_json')) {
      context.handle(
        _blocksJsonMeta,
        blocksJson.isAcceptableOrUnknown(data['blocks_json']!, _blocksJsonMeta),
      );
    }
    if (data.containsKey('exercises_json')) {
      context.handle(
        _exercisesJsonMeta,
        exercisesJson.isAcceptableOrUnknown(
          data['exercises_json']!,
          _exercisesJsonMeta,
        ),
      );
    }
    if (data.containsKey('is_published')) {
      context.handle(
        _isPublishedMeta,
        isPublished.isAcceptableOrUnknown(
          data['is_published']!,
          _isPublishedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {langId, slug},
  ];
  @override
  GrammarLessonEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GrammarLessonEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      langId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lang_id'],
      )!,
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      orderIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}order_index'],
      )!,
      titleJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title_json'],
      )!,
      prerequisiteIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}prerequisite_ids_json'],
      )!,
      linkedVerbIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_verb_ids_json'],
      )!,
      targetTensesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_tenses_json'],
      )!,
      linkedDeclensionIdsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_declension_ids_json'],
      )!,
      targetCasesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}target_cases_json'],
      )!,
      blocksJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}blocks_json'],
      )!,
      exercisesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercises_json'],
      )!,
      isPublished: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_published'],
      )!,
    );
  }

  @override
  $GrammarLessonsTableTable createAlias(String alias) {
    return $GrammarLessonsTableTable(attachedDatabase, alias);
  }
}

class GrammarLessonEntry extends DataClass
    implements Insertable<GrammarLessonEntry> {
  final int id;
  final int langId;
  final String slug;
  final String level;
  final int orderIndex;
  final String titleJson;
  final String prerequisiteIdsJson;
  final String linkedVerbIdsJson;
  final String targetTensesJson;
  final String linkedDeclensionIdsJson;
  final String targetCasesJson;
  final String blocksJson;
  final String exercisesJson;
  final bool isPublished;
  const GrammarLessonEntry({
    required this.id,
    required this.langId,
    required this.slug,
    required this.level,
    required this.orderIndex,
    required this.titleJson,
    required this.prerequisiteIdsJson,
    required this.linkedVerbIdsJson,
    required this.targetTensesJson,
    required this.linkedDeclensionIdsJson,
    required this.targetCasesJson,
    required this.blocksJson,
    required this.exercisesJson,
    required this.isPublished,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['lang_id'] = Variable<int>(langId);
    map['slug'] = Variable<String>(slug);
    map['level'] = Variable<String>(level);
    map['order_index'] = Variable<int>(orderIndex);
    map['title_json'] = Variable<String>(titleJson);
    map['prerequisite_ids_json'] = Variable<String>(prerequisiteIdsJson);
    map['linked_verb_ids_json'] = Variable<String>(linkedVerbIdsJson);
    map['target_tenses_json'] = Variable<String>(targetTensesJson);
    map['linked_declension_ids_json'] = Variable<String>(
      linkedDeclensionIdsJson,
    );
    map['target_cases_json'] = Variable<String>(targetCasesJson);
    map['blocks_json'] = Variable<String>(blocksJson);
    map['exercises_json'] = Variable<String>(exercisesJson);
    map['is_published'] = Variable<bool>(isPublished);
    return map;
  }

  GrammarLessonsTableCompanion toCompanion(bool nullToAbsent) {
    return GrammarLessonsTableCompanion(
      id: Value(id),
      langId: Value(langId),
      slug: Value(slug),
      level: Value(level),
      orderIndex: Value(orderIndex),
      titleJson: Value(titleJson),
      prerequisiteIdsJson: Value(prerequisiteIdsJson),
      linkedVerbIdsJson: Value(linkedVerbIdsJson),
      targetTensesJson: Value(targetTensesJson),
      linkedDeclensionIdsJson: Value(linkedDeclensionIdsJson),
      targetCasesJson: Value(targetCasesJson),
      blocksJson: Value(blocksJson),
      exercisesJson: Value(exercisesJson),
      isPublished: Value(isPublished),
    );
  }

  factory GrammarLessonEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GrammarLessonEntry(
      id: serializer.fromJson<int>(json['id']),
      langId: serializer.fromJson<int>(json['langId']),
      slug: serializer.fromJson<String>(json['slug']),
      level: serializer.fromJson<String>(json['level']),
      orderIndex: serializer.fromJson<int>(json['orderIndex']),
      titleJson: serializer.fromJson<String>(json['titleJson']),
      prerequisiteIdsJson: serializer.fromJson<String>(
        json['prerequisiteIdsJson'],
      ),
      linkedVerbIdsJson: serializer.fromJson<String>(json['linkedVerbIdsJson']),
      targetTensesJson: serializer.fromJson<String>(json['targetTensesJson']),
      linkedDeclensionIdsJson: serializer.fromJson<String>(
        json['linkedDeclensionIdsJson'],
      ),
      targetCasesJson: serializer.fromJson<String>(json['targetCasesJson']),
      blocksJson: serializer.fromJson<String>(json['blocksJson']),
      exercisesJson: serializer.fromJson<String>(json['exercisesJson']),
      isPublished: serializer.fromJson<bool>(json['isPublished']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'langId': serializer.toJson<int>(langId),
      'slug': serializer.toJson<String>(slug),
      'level': serializer.toJson<String>(level),
      'orderIndex': serializer.toJson<int>(orderIndex),
      'titleJson': serializer.toJson<String>(titleJson),
      'prerequisiteIdsJson': serializer.toJson<String>(prerequisiteIdsJson),
      'linkedVerbIdsJson': serializer.toJson<String>(linkedVerbIdsJson),
      'targetTensesJson': serializer.toJson<String>(targetTensesJson),
      'linkedDeclensionIdsJson': serializer.toJson<String>(
        linkedDeclensionIdsJson,
      ),
      'targetCasesJson': serializer.toJson<String>(targetCasesJson),
      'blocksJson': serializer.toJson<String>(blocksJson),
      'exercisesJson': serializer.toJson<String>(exercisesJson),
      'isPublished': serializer.toJson<bool>(isPublished),
    };
  }

  GrammarLessonEntry copyWith({
    int? id,
    int? langId,
    String? slug,
    String? level,
    int? orderIndex,
    String? titleJson,
    String? prerequisiteIdsJson,
    String? linkedVerbIdsJson,
    String? targetTensesJson,
    String? linkedDeclensionIdsJson,
    String? targetCasesJson,
    String? blocksJson,
    String? exercisesJson,
    bool? isPublished,
  }) => GrammarLessonEntry(
    id: id ?? this.id,
    langId: langId ?? this.langId,
    slug: slug ?? this.slug,
    level: level ?? this.level,
    orderIndex: orderIndex ?? this.orderIndex,
    titleJson: titleJson ?? this.titleJson,
    prerequisiteIdsJson: prerequisiteIdsJson ?? this.prerequisiteIdsJson,
    linkedVerbIdsJson: linkedVerbIdsJson ?? this.linkedVerbIdsJson,
    targetTensesJson: targetTensesJson ?? this.targetTensesJson,
    linkedDeclensionIdsJson:
        linkedDeclensionIdsJson ?? this.linkedDeclensionIdsJson,
    targetCasesJson: targetCasesJson ?? this.targetCasesJson,
    blocksJson: blocksJson ?? this.blocksJson,
    exercisesJson: exercisesJson ?? this.exercisesJson,
    isPublished: isPublished ?? this.isPublished,
  );
  GrammarLessonEntry copyWithCompanion(GrammarLessonsTableCompanion data) {
    return GrammarLessonEntry(
      id: data.id.present ? data.id.value : this.id,
      langId: data.langId.present ? data.langId.value : this.langId,
      slug: data.slug.present ? data.slug.value : this.slug,
      level: data.level.present ? data.level.value : this.level,
      orderIndex: data.orderIndex.present
          ? data.orderIndex.value
          : this.orderIndex,
      titleJson: data.titleJson.present ? data.titleJson.value : this.titleJson,
      prerequisiteIdsJson: data.prerequisiteIdsJson.present
          ? data.prerequisiteIdsJson.value
          : this.prerequisiteIdsJson,
      linkedVerbIdsJson: data.linkedVerbIdsJson.present
          ? data.linkedVerbIdsJson.value
          : this.linkedVerbIdsJson,
      targetTensesJson: data.targetTensesJson.present
          ? data.targetTensesJson.value
          : this.targetTensesJson,
      linkedDeclensionIdsJson: data.linkedDeclensionIdsJson.present
          ? data.linkedDeclensionIdsJson.value
          : this.linkedDeclensionIdsJson,
      targetCasesJson: data.targetCasesJson.present
          ? data.targetCasesJson.value
          : this.targetCasesJson,
      blocksJson: data.blocksJson.present
          ? data.blocksJson.value
          : this.blocksJson,
      exercisesJson: data.exercisesJson.present
          ? data.exercisesJson.value
          : this.exercisesJson,
      isPublished: data.isPublished.present
          ? data.isPublished.value
          : this.isPublished,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonEntry(')
          ..write('id: $id, ')
          ..write('langId: $langId, ')
          ..write('slug: $slug, ')
          ..write('level: $level, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('titleJson: $titleJson, ')
          ..write('prerequisiteIdsJson: $prerequisiteIdsJson, ')
          ..write('linkedVerbIdsJson: $linkedVerbIdsJson, ')
          ..write('targetTensesJson: $targetTensesJson, ')
          ..write('linkedDeclensionIdsJson: $linkedDeclensionIdsJson, ')
          ..write('targetCasesJson: $targetCasesJson, ')
          ..write('blocksJson: $blocksJson, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    langId,
    slug,
    level,
    orderIndex,
    titleJson,
    prerequisiteIdsJson,
    linkedVerbIdsJson,
    targetTensesJson,
    linkedDeclensionIdsJson,
    targetCasesJson,
    blocksJson,
    exercisesJson,
    isPublished,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GrammarLessonEntry &&
          other.id == this.id &&
          other.langId == this.langId &&
          other.slug == this.slug &&
          other.level == this.level &&
          other.orderIndex == this.orderIndex &&
          other.titleJson == this.titleJson &&
          other.prerequisiteIdsJson == this.prerequisiteIdsJson &&
          other.linkedVerbIdsJson == this.linkedVerbIdsJson &&
          other.targetTensesJson == this.targetTensesJson &&
          other.linkedDeclensionIdsJson == this.linkedDeclensionIdsJson &&
          other.targetCasesJson == this.targetCasesJson &&
          other.blocksJson == this.blocksJson &&
          other.exercisesJson == this.exercisesJson &&
          other.isPublished == this.isPublished);
}

class GrammarLessonsTableCompanion extends UpdateCompanion<GrammarLessonEntry> {
  final Value<int> id;
  final Value<int> langId;
  final Value<String> slug;
  final Value<String> level;
  final Value<int> orderIndex;
  final Value<String> titleJson;
  final Value<String> prerequisiteIdsJson;
  final Value<String> linkedVerbIdsJson;
  final Value<String> targetTensesJson;
  final Value<String> linkedDeclensionIdsJson;
  final Value<String> targetCasesJson;
  final Value<String> blocksJson;
  final Value<String> exercisesJson;
  final Value<bool> isPublished;
  const GrammarLessonsTableCompanion({
    this.id = const Value.absent(),
    this.langId = const Value.absent(),
    this.slug = const Value.absent(),
    this.level = const Value.absent(),
    this.orderIndex = const Value.absent(),
    this.titleJson = const Value.absent(),
    this.prerequisiteIdsJson = const Value.absent(),
    this.linkedVerbIdsJson = const Value.absent(),
    this.targetTensesJson = const Value.absent(),
    this.linkedDeclensionIdsJson = const Value.absent(),
    this.targetCasesJson = const Value.absent(),
    this.blocksJson = const Value.absent(),
    this.exercisesJson = const Value.absent(),
    this.isPublished = const Value.absent(),
  });
  GrammarLessonsTableCompanion.insert({
    this.id = const Value.absent(),
    required int langId,
    required String slug,
    required String level,
    this.orderIndex = const Value.absent(),
    this.titleJson = const Value.absent(),
    this.prerequisiteIdsJson = const Value.absent(),
    this.linkedVerbIdsJson = const Value.absent(),
    this.targetTensesJson = const Value.absent(),
    this.linkedDeclensionIdsJson = const Value.absent(),
    this.targetCasesJson = const Value.absent(),
    this.blocksJson = const Value.absent(),
    this.exercisesJson = const Value.absent(),
    this.isPublished = const Value.absent(),
  }) : langId = Value(langId),
       slug = Value(slug),
       level = Value(level);
  static Insertable<GrammarLessonEntry> custom({
    Expression<int>? id,
    Expression<int>? langId,
    Expression<String>? slug,
    Expression<String>? level,
    Expression<int>? orderIndex,
    Expression<String>? titleJson,
    Expression<String>? prerequisiteIdsJson,
    Expression<String>? linkedVerbIdsJson,
    Expression<String>? targetTensesJson,
    Expression<String>? linkedDeclensionIdsJson,
    Expression<String>? targetCasesJson,
    Expression<String>? blocksJson,
    Expression<String>? exercisesJson,
    Expression<bool>? isPublished,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (langId != null) 'lang_id': langId,
      if (slug != null) 'slug': slug,
      if (level != null) 'level': level,
      if (orderIndex != null) 'order_index': orderIndex,
      if (titleJson != null) 'title_json': titleJson,
      if (prerequisiteIdsJson != null)
        'prerequisite_ids_json': prerequisiteIdsJson,
      if (linkedVerbIdsJson != null) 'linked_verb_ids_json': linkedVerbIdsJson,
      if (targetTensesJson != null) 'target_tenses_json': targetTensesJson,
      if (linkedDeclensionIdsJson != null)
        'linked_declension_ids_json': linkedDeclensionIdsJson,
      if (targetCasesJson != null) 'target_cases_json': targetCasesJson,
      if (blocksJson != null) 'blocks_json': blocksJson,
      if (exercisesJson != null) 'exercises_json': exercisesJson,
      if (isPublished != null) 'is_published': isPublished,
    });
  }

  GrammarLessonsTableCompanion copyWith({
    Value<int>? id,
    Value<int>? langId,
    Value<String>? slug,
    Value<String>? level,
    Value<int>? orderIndex,
    Value<String>? titleJson,
    Value<String>? prerequisiteIdsJson,
    Value<String>? linkedVerbIdsJson,
    Value<String>? targetTensesJson,
    Value<String>? linkedDeclensionIdsJson,
    Value<String>? targetCasesJson,
    Value<String>? blocksJson,
    Value<String>? exercisesJson,
    Value<bool>? isPublished,
  }) {
    return GrammarLessonsTableCompanion(
      id: id ?? this.id,
      langId: langId ?? this.langId,
      slug: slug ?? this.slug,
      level: level ?? this.level,
      orderIndex: orderIndex ?? this.orderIndex,
      titleJson: titleJson ?? this.titleJson,
      prerequisiteIdsJson: prerequisiteIdsJson ?? this.prerequisiteIdsJson,
      linkedVerbIdsJson: linkedVerbIdsJson ?? this.linkedVerbIdsJson,
      targetTensesJson: targetTensesJson ?? this.targetTensesJson,
      linkedDeclensionIdsJson:
          linkedDeclensionIdsJson ?? this.linkedDeclensionIdsJson,
      targetCasesJson: targetCasesJson ?? this.targetCasesJson,
      blocksJson: blocksJson ?? this.blocksJson,
      exercisesJson: exercisesJson ?? this.exercisesJson,
      isPublished: isPublished ?? this.isPublished,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (langId.present) {
      map['lang_id'] = Variable<int>(langId.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (orderIndex.present) {
      map['order_index'] = Variable<int>(orderIndex.value);
    }
    if (titleJson.present) {
      map['title_json'] = Variable<String>(titleJson.value);
    }
    if (prerequisiteIdsJson.present) {
      map['prerequisite_ids_json'] = Variable<String>(
        prerequisiteIdsJson.value,
      );
    }
    if (linkedVerbIdsJson.present) {
      map['linked_verb_ids_json'] = Variable<String>(linkedVerbIdsJson.value);
    }
    if (targetTensesJson.present) {
      map['target_tenses_json'] = Variable<String>(targetTensesJson.value);
    }
    if (linkedDeclensionIdsJson.present) {
      map['linked_declension_ids_json'] = Variable<String>(
        linkedDeclensionIdsJson.value,
      );
    }
    if (targetCasesJson.present) {
      map['target_cases_json'] = Variable<String>(targetCasesJson.value);
    }
    if (blocksJson.present) {
      map['blocks_json'] = Variable<String>(blocksJson.value);
    }
    if (exercisesJson.present) {
      map['exercises_json'] = Variable<String>(exercisesJson.value);
    }
    if (isPublished.present) {
      map['is_published'] = Variable<bool>(isPublished.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GrammarLessonsTableCompanion(')
          ..write('id: $id, ')
          ..write('langId: $langId, ')
          ..write('slug: $slug, ')
          ..write('level: $level, ')
          ..write('orderIndex: $orderIndex, ')
          ..write('titleJson: $titleJson, ')
          ..write('prerequisiteIdsJson: $prerequisiteIdsJson, ')
          ..write('linkedVerbIdsJson: $linkedVerbIdsJson, ')
          ..write('targetTensesJson: $targetTensesJson, ')
          ..write('linkedDeclensionIdsJson: $linkedDeclensionIdsJson, ')
          ..write('targetCasesJson: $targetCasesJson, ')
          ..write('blocksJson: $blocksJson, ')
          ..write('exercisesJson: $exercisesJson, ')
          ..write('isPublished: $isPublished')
          ..write(')'))
        .toString();
  }
}

class $LessonProgressTableTable extends LessonProgressTable
    with TableInfo<$LessonProgressTableTable, LessonProgressEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LessonProgressTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _userKeyMeta = const VerificationMeta(
    'userKey',
  );
  @override
  late final GeneratedColumn<String> userKey = GeneratedColumn<String>(
    'user_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('local'),
  );
  static const VerificationMeta _lessonIdMeta = const VerificationMeta(
    'lessonId',
  );
  @override
  late final GeneratedColumn<int> lessonId = GeneratedColumn<int>(
    'lesson_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exerciseResultsJsonMeta =
      const VerificationMeta('exerciseResultsJson');
  @override
  late final GeneratedColumn<String> exerciseResultsJson =
      GeneratedColumn<String>(
        'exercise_results_json',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('{}'),
      );
  static const VerificationMeta _scoreMeta = const VerificationMeta('score');
  @override
  late final GeneratedColumn<double> score = GeneratedColumn<double>(
    'score',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _lastSeenAtMeta = const VerificationMeta(
    'lastSeenAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSeenAt = GeneratedColumn<DateTime>(
    'last_seen_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _nextDueAtMeta = const VerificationMeta(
    'nextDueAt',
  );
  @override
  late final GeneratedColumn<DateTime> nextDueAt = GeneratedColumn<DateTime>(
    'next_due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userKey,
    lessonId,
    exerciseResultsJson,
    score,
    lastSeenAt,
    nextDueAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'lesson_progress_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LessonProgressEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('user_key')) {
      context.handle(
        _userKeyMeta,
        userKey.isAcceptableOrUnknown(data['user_key']!, _userKeyMeta),
      );
    }
    if (data.containsKey('lesson_id')) {
      context.handle(
        _lessonIdMeta,
        lessonId.isAcceptableOrUnknown(data['lesson_id']!, _lessonIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lessonIdMeta);
    }
    if (data.containsKey('exercise_results_json')) {
      context.handle(
        _exerciseResultsJsonMeta,
        exerciseResultsJson.isAcceptableOrUnknown(
          data['exercise_results_json']!,
          _exerciseResultsJsonMeta,
        ),
      );
    }
    if (data.containsKey('score')) {
      context.handle(
        _scoreMeta,
        score.isAcceptableOrUnknown(data['score']!, _scoreMeta),
      );
    }
    if (data.containsKey('last_seen_at')) {
      context.handle(
        _lastSeenAtMeta,
        lastSeenAt.isAcceptableOrUnknown(
          data['last_seen_at']!,
          _lastSeenAtMeta,
        ),
      );
    }
    if (data.containsKey('next_due_at')) {
      context.handle(
        _nextDueAtMeta,
        nextDueAt.isAcceptableOrUnknown(data['next_due_at']!, _nextDueAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {userKey, lessonId},
  ];
  @override
  LessonProgressEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LessonProgressEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      userKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_key'],
      )!,
      lessonId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lesson_id'],
      )!,
      exerciseResultsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}exercise_results_json'],
      )!,
      score: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}score'],
      )!,
      lastSeenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_seen_at'],
      )!,
      nextDueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_due_at'],
      ),
    );
  }

  @override
  $LessonProgressTableTable createAlias(String alias) {
    return $LessonProgressTableTable(attachedDatabase, alias);
  }
}

class LessonProgressEntry extends DataClass
    implements Insertable<LessonProgressEntry> {
  final int id;
  final String userKey;
  final int lessonId;
  final String exerciseResultsJson;
  final double score;
  final DateTime lastSeenAt;
  final DateTime? nextDueAt;
  const LessonProgressEntry({
    required this.id,
    required this.userKey,
    required this.lessonId,
    required this.exerciseResultsJson,
    required this.score,
    required this.lastSeenAt,
    this.nextDueAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['user_key'] = Variable<String>(userKey);
    map['lesson_id'] = Variable<int>(lessonId);
    map['exercise_results_json'] = Variable<String>(exerciseResultsJson);
    map['score'] = Variable<double>(score);
    map['last_seen_at'] = Variable<DateTime>(lastSeenAt);
    if (!nullToAbsent || nextDueAt != null) {
      map['next_due_at'] = Variable<DateTime>(nextDueAt);
    }
    return map;
  }

  LessonProgressTableCompanion toCompanion(bool nullToAbsent) {
    return LessonProgressTableCompanion(
      id: Value(id),
      userKey: Value(userKey),
      lessonId: Value(lessonId),
      exerciseResultsJson: Value(exerciseResultsJson),
      score: Value(score),
      lastSeenAt: Value(lastSeenAt),
      nextDueAt: nextDueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(nextDueAt),
    );
  }

  factory LessonProgressEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LessonProgressEntry(
      id: serializer.fromJson<int>(json['id']),
      userKey: serializer.fromJson<String>(json['userKey']),
      lessonId: serializer.fromJson<int>(json['lessonId']),
      exerciseResultsJson: serializer.fromJson<String>(
        json['exerciseResultsJson'],
      ),
      score: serializer.fromJson<double>(json['score']),
      lastSeenAt: serializer.fromJson<DateTime>(json['lastSeenAt']),
      nextDueAt: serializer.fromJson<DateTime?>(json['nextDueAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'userKey': serializer.toJson<String>(userKey),
      'lessonId': serializer.toJson<int>(lessonId),
      'exerciseResultsJson': serializer.toJson<String>(exerciseResultsJson),
      'score': serializer.toJson<double>(score),
      'lastSeenAt': serializer.toJson<DateTime>(lastSeenAt),
      'nextDueAt': serializer.toJson<DateTime?>(nextDueAt),
    };
  }

  LessonProgressEntry copyWith({
    int? id,
    String? userKey,
    int? lessonId,
    String? exerciseResultsJson,
    double? score,
    DateTime? lastSeenAt,
    Value<DateTime?> nextDueAt = const Value.absent(),
  }) => LessonProgressEntry(
    id: id ?? this.id,
    userKey: userKey ?? this.userKey,
    lessonId: lessonId ?? this.lessonId,
    exerciseResultsJson: exerciseResultsJson ?? this.exerciseResultsJson,
    score: score ?? this.score,
    lastSeenAt: lastSeenAt ?? this.lastSeenAt,
    nextDueAt: nextDueAt.present ? nextDueAt.value : this.nextDueAt,
  );
  LessonProgressEntry copyWithCompanion(LessonProgressTableCompanion data) {
    return LessonProgressEntry(
      id: data.id.present ? data.id.value : this.id,
      userKey: data.userKey.present ? data.userKey.value : this.userKey,
      lessonId: data.lessonId.present ? data.lessonId.value : this.lessonId,
      exerciseResultsJson: data.exerciseResultsJson.present
          ? data.exerciseResultsJson.value
          : this.exerciseResultsJson,
      score: data.score.present ? data.score.value : this.score,
      lastSeenAt: data.lastSeenAt.present
          ? data.lastSeenAt.value
          : this.lastSeenAt,
      nextDueAt: data.nextDueAt.present ? data.nextDueAt.value : this.nextDueAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressEntry(')
          ..write('id: $id, ')
          ..write('userKey: $userKey, ')
          ..write('lessonId: $lessonId, ')
          ..write('exerciseResultsJson: $exerciseResultsJson, ')
          ..write('score: $score, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('nextDueAt: $nextDueAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    userKey,
    lessonId,
    exerciseResultsJson,
    score,
    lastSeenAt,
    nextDueAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LessonProgressEntry &&
          other.id == this.id &&
          other.userKey == this.userKey &&
          other.lessonId == this.lessonId &&
          other.exerciseResultsJson == this.exerciseResultsJson &&
          other.score == this.score &&
          other.lastSeenAt == this.lastSeenAt &&
          other.nextDueAt == this.nextDueAt);
}

class LessonProgressTableCompanion
    extends UpdateCompanion<LessonProgressEntry> {
  final Value<int> id;
  final Value<String> userKey;
  final Value<int> lessonId;
  final Value<String> exerciseResultsJson;
  final Value<double> score;
  final Value<DateTime> lastSeenAt;
  final Value<DateTime?> nextDueAt;
  const LessonProgressTableCompanion({
    this.id = const Value.absent(),
    this.userKey = const Value.absent(),
    this.lessonId = const Value.absent(),
    this.exerciseResultsJson = const Value.absent(),
    this.score = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.nextDueAt = const Value.absent(),
  });
  LessonProgressTableCompanion.insert({
    this.id = const Value.absent(),
    this.userKey = const Value.absent(),
    required int lessonId,
    this.exerciseResultsJson = const Value.absent(),
    this.score = const Value.absent(),
    this.lastSeenAt = const Value.absent(),
    this.nextDueAt = const Value.absent(),
  }) : lessonId = Value(lessonId);
  static Insertable<LessonProgressEntry> custom({
    Expression<int>? id,
    Expression<String>? userKey,
    Expression<int>? lessonId,
    Expression<String>? exerciseResultsJson,
    Expression<double>? score,
    Expression<DateTime>? lastSeenAt,
    Expression<DateTime>? nextDueAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userKey != null) 'user_key': userKey,
      if (lessonId != null) 'lesson_id': lessonId,
      if (exerciseResultsJson != null)
        'exercise_results_json': exerciseResultsJson,
      if (score != null) 'score': score,
      if (lastSeenAt != null) 'last_seen_at': lastSeenAt,
      if (nextDueAt != null) 'next_due_at': nextDueAt,
    });
  }

  LessonProgressTableCompanion copyWith({
    Value<int>? id,
    Value<String>? userKey,
    Value<int>? lessonId,
    Value<String>? exerciseResultsJson,
    Value<double>? score,
    Value<DateTime>? lastSeenAt,
    Value<DateTime?>? nextDueAt,
  }) {
    return LessonProgressTableCompanion(
      id: id ?? this.id,
      userKey: userKey ?? this.userKey,
      lessonId: lessonId ?? this.lessonId,
      exerciseResultsJson: exerciseResultsJson ?? this.exerciseResultsJson,
      score: score ?? this.score,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      nextDueAt: nextDueAt ?? this.nextDueAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (userKey.present) {
      map['user_key'] = Variable<String>(userKey.value);
    }
    if (lessonId.present) {
      map['lesson_id'] = Variable<int>(lessonId.value);
    }
    if (exerciseResultsJson.present) {
      map['exercise_results_json'] = Variable<String>(
        exerciseResultsJson.value,
      );
    }
    if (score.present) {
      map['score'] = Variable<double>(score.value);
    }
    if (lastSeenAt.present) {
      map['last_seen_at'] = Variable<DateTime>(lastSeenAt.value);
    }
    if (nextDueAt.present) {
      map['next_due_at'] = Variable<DateTime>(nextDueAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LessonProgressTableCompanion(')
          ..write('id: $id, ')
          ..write('userKey: $userKey, ')
          ..write('lessonId: $lessonId, ')
          ..write('exerciseResultsJson: $exerciseResultsJson, ')
          ..write('score: $score, ')
          ..write('lastSeenAt: $lastSeenAt, ')
          ..write('nextDueAt: $nextDueAt')
          ..write(')'))
        .toString();
  }
}

class $LevelCoverageTableTable extends LevelCoverageTable
    with TableInfo<$LevelCoverageTableTable, LevelCoverageEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LevelCoverageTableTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _wordCountMeta = const VerificationMeta(
    'wordCount',
  );
  @override
  late final GeneratedColumn<int> wordCount = GeneratedColumn<int>(
    'word_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quotaMeta = const VerificationMeta('quota');
  @override
  late final GeneratedColumn<int> quota = GeneratedColumn<int>(
    'quota',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    language,
    level,
    wordCount,
    quota,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'level_coverage_table';
  @override
  VerificationContext validateIntegrity(
    Insertable<LevelCoverageEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('word_count')) {
      context.handle(
        _wordCountMeta,
        wordCount.isAcceptableOrUnknown(data['word_count']!, _wordCountMeta),
      );
    } else if (isInserting) {
      context.missing(_wordCountMeta);
    }
    if (data.containsKey('quota')) {
      context.handle(
        _quotaMeta,
        quota.isAcceptableOrUnknown(data['quota']!, _quotaMeta),
      );
    } else if (isInserting) {
      context.missing(_quotaMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {language, level};
  @override
  LevelCoverageEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LevelCoverageEntry(
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      wordCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}word_count'],
      )!,
      quota: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}quota'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $LevelCoverageTableTable createAlias(String alias) {
    return $LevelCoverageTableTable(attachedDatabase, alias);
  }
}

class LevelCoverageEntry extends DataClass
    implements Insertable<LevelCoverageEntry> {
  final String language;
  final String level;
  final int wordCount;
  final int quota;
  final DateTime updatedAt;
  const LevelCoverageEntry({
    required this.language,
    required this.level,
    required this.wordCount,
    required this.quota,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['language'] = Variable<String>(language);
    map['level'] = Variable<String>(level);
    map['word_count'] = Variable<int>(wordCount);
    map['quota'] = Variable<int>(quota);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  LevelCoverageTableCompanion toCompanion(bool nullToAbsent) {
    return LevelCoverageTableCompanion(
      language: Value(language),
      level: Value(level),
      wordCount: Value(wordCount),
      quota: Value(quota),
      updatedAt: Value(updatedAt),
    );
  }

  factory LevelCoverageEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LevelCoverageEntry(
      language: serializer.fromJson<String>(json['language']),
      level: serializer.fromJson<String>(json['level']),
      wordCount: serializer.fromJson<int>(json['wordCount']),
      quota: serializer.fromJson<int>(json['quota']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'language': serializer.toJson<String>(language),
      'level': serializer.toJson<String>(level),
      'wordCount': serializer.toJson<int>(wordCount),
      'quota': serializer.toJson<int>(quota),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  LevelCoverageEntry copyWith({
    String? language,
    String? level,
    int? wordCount,
    int? quota,
    DateTime? updatedAt,
  }) => LevelCoverageEntry(
    language: language ?? this.language,
    level: level ?? this.level,
    wordCount: wordCount ?? this.wordCount,
    quota: quota ?? this.quota,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  LevelCoverageEntry copyWithCompanion(LevelCoverageTableCompanion data) {
    return LevelCoverageEntry(
      language: data.language.present ? data.language.value : this.language,
      level: data.level.present ? data.level.value : this.level,
      wordCount: data.wordCount.present ? data.wordCount.value : this.wordCount,
      quota: data.quota.present ? data.quota.value : this.quota,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LevelCoverageEntry(')
          ..write('language: $language, ')
          ..write('level: $level, ')
          ..write('wordCount: $wordCount, ')
          ..write('quota: $quota, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(language, level, wordCount, quota, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LevelCoverageEntry &&
          other.language == this.language &&
          other.level == this.level &&
          other.wordCount == this.wordCount &&
          other.quota == this.quota &&
          other.updatedAt == this.updatedAt);
}

class LevelCoverageTableCompanion extends UpdateCompanion<LevelCoverageEntry> {
  final Value<String> language;
  final Value<String> level;
  final Value<int> wordCount;
  final Value<int> quota;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const LevelCoverageTableCompanion({
    this.language = const Value.absent(),
    this.level = const Value.absent(),
    this.wordCount = const Value.absent(),
    this.quota = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LevelCoverageTableCompanion.insert({
    required String language,
    required String level,
    required int wordCount,
    required int quota,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : language = Value(language),
       level = Value(level),
       wordCount = Value(wordCount),
       quota = Value(quota);
  static Insertable<LevelCoverageEntry> custom({
    Expression<String>? language,
    Expression<String>? level,
    Expression<int>? wordCount,
    Expression<int>? quota,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (language != null) 'language': language,
      if (level != null) 'level': level,
      if (wordCount != null) 'word_count': wordCount,
      if (quota != null) 'quota': quota,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LevelCoverageTableCompanion copyWith({
    Value<String>? language,
    Value<String>? level,
    Value<int>? wordCount,
    Value<int>? quota,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return LevelCoverageTableCompanion(
      language: language ?? this.language,
      level: level ?? this.level,
      wordCount: wordCount ?? this.wordCount,
      quota: quota ?? this.quota,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (wordCount.present) {
      map['word_count'] = Variable<int>(wordCount.value);
    }
    if (quota.present) {
      map['quota'] = Variable<int>(quota.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LevelCoverageTableCompanion(')
          ..write('language: $language, ')
          ..write('level: $level, ')
          ..write('wordCount: $wordCount, ')
          ..write('quota: $quota, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
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
  late final $LanguagesTableTable languagesTable = $LanguagesTableTable(this);
  late final $ConjugationsTableTable conjugationsTable =
      $ConjugationsTableTable(this);
  late final $DeclensionsTableTable declensionsTable = $DeclensionsTableTable(
    this,
  );
  late final $GrammarLessonsTableTable grammarLessonsTable =
      $GrammarLessonsTableTable(this);
  late final $LessonProgressTableTable lessonProgressTable =
      $LessonProgressTableTable(this);
  late final $LevelCoverageTableTable levelCoverageTable =
      $LevelCoverageTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    wordsTable,
    wordProgressTable,
    unimorphFormsTable,
    grammarRulesTable,
    languagesTable,
    conjugationsTable,
    declensionsTable,
    grammarLessonsTable,
    lessonProgressTable,
    levelCoverageTable,
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
typedef $$LanguagesTableTableCreateCompanionBuilder =
    LanguagesTableCompanion Function({
      Value<int> id,
      required String code,
      required String nameL10nJson,
      Value<bool> isNonLatin,
      required String grammarProfileJson,
    });
typedef $$LanguagesTableTableUpdateCompanionBuilder =
    LanguagesTableCompanion Function({
      Value<int> id,
      Value<String> code,
      Value<String> nameL10nJson,
      Value<bool> isNonLatin,
      Value<String> grammarProfileJson,
    });

class $$LanguagesTableTableFilterComposer
    extends Composer<_$AppDatabase, $LanguagesTableTable> {
  $$LanguagesTableTableFilterComposer({
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

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nameL10nJson => $composableBuilder(
    column: $table.nameL10nJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isNonLatin => $composableBuilder(
    column: $table.isNonLatin,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get grammarProfileJson => $composableBuilder(
    column: $table.grammarProfileJson,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LanguagesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LanguagesTableTable> {
  $$LanguagesTableTableOrderingComposer({
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

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nameL10nJson => $composableBuilder(
    column: $table.nameL10nJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isNonLatin => $composableBuilder(
    column: $table.isNonLatin,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get grammarProfileJson => $composableBuilder(
    column: $table.grammarProfileJson,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LanguagesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LanguagesTableTable> {
  $$LanguagesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<String> get nameL10nJson => $composableBuilder(
    column: $table.nameL10nJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isNonLatin => $composableBuilder(
    column: $table.isNonLatin,
    builder: (column) => column,
  );

  GeneratedColumn<String> get grammarProfileJson => $composableBuilder(
    column: $table.grammarProfileJson,
    builder: (column) => column,
  );
}

class $$LanguagesTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LanguagesTableTable,
          LanguageEntry,
          $$LanguagesTableTableFilterComposer,
          $$LanguagesTableTableOrderingComposer,
          $$LanguagesTableTableAnnotationComposer,
          $$LanguagesTableTableCreateCompanionBuilder,
          $$LanguagesTableTableUpdateCompanionBuilder,
          (
            LanguageEntry,
            BaseReferences<_$AppDatabase, $LanguagesTableTable, LanguageEntry>,
          ),
          LanguageEntry,
          PrefetchHooks Function()
        > {
  $$LanguagesTableTableTableManager(
    _$AppDatabase db,
    $LanguagesTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LanguagesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LanguagesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LanguagesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<String> nameL10nJson = const Value.absent(),
                Value<bool> isNonLatin = const Value.absent(),
                Value<String> grammarProfileJson = const Value.absent(),
              }) => LanguagesTableCompanion(
                id: id,
                code: code,
                nameL10nJson: nameL10nJson,
                isNonLatin: isNonLatin,
                grammarProfileJson: grammarProfileJson,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String code,
                required String nameL10nJson,
                Value<bool> isNonLatin = const Value.absent(),
                required String grammarProfileJson,
              }) => LanguagesTableCompanion.insert(
                id: id,
                code: code,
                nameL10nJson: nameL10nJson,
                isNonLatin: isNonLatin,
                grammarProfileJson: grammarProfileJson,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LanguagesTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LanguagesTableTable,
      LanguageEntry,
      $$LanguagesTableTableFilterComposer,
      $$LanguagesTableTableOrderingComposer,
      $$LanguagesTableTableAnnotationComposer,
      $$LanguagesTableTableCreateCompanionBuilder,
      $$LanguagesTableTableUpdateCompanionBuilder,
      (
        LanguageEntry,
        BaseReferences<_$AppDatabase, $LanguagesTableTable, LanguageEntry>,
      ),
      LanguageEntry,
      PrefetchHooks Function()
    >;
typedef $$ConjugationsTableTableCreateCompanionBuilder =
    ConjugationsTableCompanion Function({
      Value<int> id,
      required int langId,
      required String lemma,
      Value<String?> verbGroup,
      Value<String> auxiliariesJson,
      Value<bool> isPronominal,
      Value<String?> reflexiveCase,
      Value<bool> isIrregular,
      Value<bool> isDefective,
      Value<String> generalNoteJson,
      Value<String> formsJson,
      Value<String> source,
      Value<bool> isPublished,
    });
typedef $$ConjugationsTableTableUpdateCompanionBuilder =
    ConjugationsTableCompanion Function({
      Value<int> id,
      Value<int> langId,
      Value<String> lemma,
      Value<String?> verbGroup,
      Value<String> auxiliariesJson,
      Value<bool> isPronominal,
      Value<String?> reflexiveCase,
      Value<bool> isIrregular,
      Value<bool> isDefective,
      Value<String> generalNoteJson,
      Value<String> formsJson,
      Value<String> source,
      Value<bool> isPublished,
    });

class $$ConjugationsTableTableFilterComposer
    extends Composer<_$AppDatabase, $ConjugationsTableTable> {
  $$ConjugationsTableTableFilterComposer({
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

  ColumnFilters<int> get langId => $composableBuilder(
    column: $table.langId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get verbGroup => $composableBuilder(
    column: $table.verbGroup,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get auxiliariesJson => $composableBuilder(
    column: $table.auxiliariesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPronominal => $composableBuilder(
    column: $table.isPronominal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reflexiveCase => $composableBuilder(
    column: $table.reflexiveCase,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIrregular => $composableBuilder(
    column: $table.isIrregular,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefective => $composableBuilder(
    column: $table.isDefective,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generalNoteJson => $composableBuilder(
    column: $table.generalNoteJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formsJson => $composableBuilder(
    column: $table.formsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ConjugationsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $ConjugationsTableTable> {
  $$ConjugationsTableTableOrderingComposer({
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

  ColumnOrderings<int> get langId => $composableBuilder(
    column: $table.langId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get verbGroup => $composableBuilder(
    column: $table.verbGroup,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get auxiliariesJson => $composableBuilder(
    column: $table.auxiliariesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPronominal => $composableBuilder(
    column: $table.isPronominal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reflexiveCase => $composableBuilder(
    column: $table.reflexiveCase,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIrregular => $composableBuilder(
    column: $table.isIrregular,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefective => $composableBuilder(
    column: $table.isDefective,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generalNoteJson => $composableBuilder(
    column: $table.generalNoteJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formsJson => $composableBuilder(
    column: $table.formsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ConjugationsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $ConjugationsTableTable> {
  $$ConjugationsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get langId =>
      $composableBuilder(column: $table.langId, builder: (column) => column);

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);

  GeneratedColumn<String> get verbGroup =>
      $composableBuilder(column: $table.verbGroup, builder: (column) => column);

  GeneratedColumn<String> get auxiliariesJson => $composableBuilder(
    column: $table.auxiliariesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPronominal => $composableBuilder(
    column: $table.isPronominal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reflexiveCase => $composableBuilder(
    column: $table.reflexiveCase,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isIrregular => $composableBuilder(
    column: $table.isIrregular,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDefective => $composableBuilder(
    column: $table.isDefective,
    builder: (column) => column,
  );

  GeneratedColumn<String> get generalNoteJson => $composableBuilder(
    column: $table.generalNoteJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get formsJson =>
      $composableBuilder(column: $table.formsJson, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );
}

class $$ConjugationsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ConjugationsTableTable,
          ConjugationEntry,
          $$ConjugationsTableTableFilterComposer,
          $$ConjugationsTableTableOrderingComposer,
          $$ConjugationsTableTableAnnotationComposer,
          $$ConjugationsTableTableCreateCompanionBuilder,
          $$ConjugationsTableTableUpdateCompanionBuilder,
          (
            ConjugationEntry,
            BaseReferences<
              _$AppDatabase,
              $ConjugationsTableTable,
              ConjugationEntry
            >,
          ),
          ConjugationEntry,
          PrefetchHooks Function()
        > {
  $$ConjugationsTableTableTableManager(
    _$AppDatabase db,
    $ConjugationsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ConjugationsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ConjugationsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ConjugationsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> langId = const Value.absent(),
                Value<String> lemma = const Value.absent(),
                Value<String?> verbGroup = const Value.absent(),
                Value<String> auxiliariesJson = const Value.absent(),
                Value<bool> isPronominal = const Value.absent(),
                Value<String?> reflexiveCase = const Value.absent(),
                Value<bool> isIrregular = const Value.absent(),
                Value<bool> isDefective = const Value.absent(),
                Value<String> generalNoteJson = const Value.absent(),
                Value<String> formsJson = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
              }) => ConjugationsTableCompanion(
                id: id,
                langId: langId,
                lemma: lemma,
                verbGroup: verbGroup,
                auxiliariesJson: auxiliariesJson,
                isPronominal: isPronominal,
                reflexiveCase: reflexiveCase,
                isIrregular: isIrregular,
                isDefective: isDefective,
                generalNoteJson: generalNoteJson,
                formsJson: formsJson,
                source: source,
                isPublished: isPublished,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int langId,
                required String lemma,
                Value<String?> verbGroup = const Value.absent(),
                Value<String> auxiliariesJson = const Value.absent(),
                Value<bool> isPronominal = const Value.absent(),
                Value<String?> reflexiveCase = const Value.absent(),
                Value<bool> isIrregular = const Value.absent(),
                Value<bool> isDefective = const Value.absent(),
                Value<String> generalNoteJson = const Value.absent(),
                Value<String> formsJson = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
              }) => ConjugationsTableCompanion.insert(
                id: id,
                langId: langId,
                lemma: lemma,
                verbGroup: verbGroup,
                auxiliariesJson: auxiliariesJson,
                isPronominal: isPronominal,
                reflexiveCase: reflexiveCase,
                isIrregular: isIrregular,
                isDefective: isDefective,
                generalNoteJson: generalNoteJson,
                formsJson: formsJson,
                source: source,
                isPublished: isPublished,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ConjugationsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ConjugationsTableTable,
      ConjugationEntry,
      $$ConjugationsTableTableFilterComposer,
      $$ConjugationsTableTableOrderingComposer,
      $$ConjugationsTableTableAnnotationComposer,
      $$ConjugationsTableTableCreateCompanionBuilder,
      $$ConjugationsTableTableUpdateCompanionBuilder,
      (
        ConjugationEntry,
        BaseReferences<
          _$AppDatabase,
          $ConjugationsTableTable,
          ConjugationEntry
        >,
      ),
      ConjugationEntry,
      PrefetchHooks Function()
    >;
typedef $$DeclensionsTableTableCreateCompanionBuilder =
    DeclensionsTableCompanion Function({
      Value<int> id,
      required int langId,
      required String lemma,
      required String pos,
      Value<String?> gender,
      Value<String?> declensionClass,
      Value<bool> isIrregular,
      Value<bool> isInvariable,
      Value<String> generalNoteJson,
      Value<String> formsJson,
      Value<String> source,
      Value<bool> isPublished,
    });
typedef $$DeclensionsTableTableUpdateCompanionBuilder =
    DeclensionsTableCompanion Function({
      Value<int> id,
      Value<int> langId,
      Value<String> lemma,
      Value<String> pos,
      Value<String?> gender,
      Value<String?> declensionClass,
      Value<bool> isIrregular,
      Value<bool> isInvariable,
      Value<String> generalNoteJson,
      Value<String> formsJson,
      Value<String> source,
      Value<bool> isPublished,
    });

class $$DeclensionsTableTableFilterComposer
    extends Composer<_$AppDatabase, $DeclensionsTableTable> {
  $$DeclensionsTableTableFilterComposer({
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

  ColumnFilters<int> get langId => $composableBuilder(
    column: $table.langId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get declensionClass => $composableBuilder(
    column: $table.declensionClass,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isIrregular => $composableBuilder(
    column: $table.isIrregular,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isInvariable => $composableBuilder(
    column: $table.isInvariable,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get generalNoteJson => $composableBuilder(
    column: $table.generalNoteJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get formsJson => $composableBuilder(
    column: $table.formsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeclensionsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $DeclensionsTableTable> {
  $$DeclensionsTableTableOrderingComposer({
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

  ColumnOrderings<int> get langId => $composableBuilder(
    column: $table.langId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lemma => $composableBuilder(
    column: $table.lemma,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gender => $composableBuilder(
    column: $table.gender,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get declensionClass => $composableBuilder(
    column: $table.declensionClass,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isIrregular => $composableBuilder(
    column: $table.isIrregular,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isInvariable => $composableBuilder(
    column: $table.isInvariable,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get generalNoteJson => $composableBuilder(
    column: $table.generalNoteJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get formsJson => $composableBuilder(
    column: $table.formsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get source => $composableBuilder(
    column: $table.source,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeclensionsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeclensionsTableTable> {
  $$DeclensionsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get langId =>
      $composableBuilder(column: $table.langId, builder: (column) => column);

  GeneratedColumn<String> get lemma =>
      $composableBuilder(column: $table.lemma, builder: (column) => column);

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<String> get gender =>
      $composableBuilder(column: $table.gender, builder: (column) => column);

  GeneratedColumn<String> get declensionClass => $composableBuilder(
    column: $table.declensionClass,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isIrregular => $composableBuilder(
    column: $table.isIrregular,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isInvariable => $composableBuilder(
    column: $table.isInvariable,
    builder: (column) => column,
  );

  GeneratedColumn<String> get generalNoteJson => $composableBuilder(
    column: $table.generalNoteJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get formsJson =>
      $composableBuilder(column: $table.formsJson, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );
}

class $$DeclensionsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeclensionsTableTable,
          DeclensionEntry,
          $$DeclensionsTableTableFilterComposer,
          $$DeclensionsTableTableOrderingComposer,
          $$DeclensionsTableTableAnnotationComposer,
          $$DeclensionsTableTableCreateCompanionBuilder,
          $$DeclensionsTableTableUpdateCompanionBuilder,
          (
            DeclensionEntry,
            BaseReferences<
              _$AppDatabase,
              $DeclensionsTableTable,
              DeclensionEntry
            >,
          ),
          DeclensionEntry,
          PrefetchHooks Function()
        > {
  $$DeclensionsTableTableTableManager(
    _$AppDatabase db,
    $DeclensionsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeclensionsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeclensionsTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeclensionsTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> langId = const Value.absent(),
                Value<String> lemma = const Value.absent(),
                Value<String> pos = const Value.absent(),
                Value<String?> gender = const Value.absent(),
                Value<String?> declensionClass = const Value.absent(),
                Value<bool> isIrregular = const Value.absent(),
                Value<bool> isInvariable = const Value.absent(),
                Value<String> generalNoteJson = const Value.absent(),
                Value<String> formsJson = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
              }) => DeclensionsTableCompanion(
                id: id,
                langId: langId,
                lemma: lemma,
                pos: pos,
                gender: gender,
                declensionClass: declensionClass,
                isIrregular: isIrregular,
                isInvariable: isInvariable,
                generalNoteJson: generalNoteJson,
                formsJson: formsJson,
                source: source,
                isPublished: isPublished,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int langId,
                required String lemma,
                required String pos,
                Value<String?> gender = const Value.absent(),
                Value<String?> declensionClass = const Value.absent(),
                Value<bool> isIrregular = const Value.absent(),
                Value<bool> isInvariable = const Value.absent(),
                Value<String> generalNoteJson = const Value.absent(),
                Value<String> formsJson = const Value.absent(),
                Value<String> source = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
              }) => DeclensionsTableCompanion.insert(
                id: id,
                langId: langId,
                lemma: lemma,
                pos: pos,
                gender: gender,
                declensionClass: declensionClass,
                isIrregular: isIrregular,
                isInvariable: isInvariable,
                generalNoteJson: generalNoteJson,
                formsJson: formsJson,
                source: source,
                isPublished: isPublished,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeclensionsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeclensionsTableTable,
      DeclensionEntry,
      $$DeclensionsTableTableFilterComposer,
      $$DeclensionsTableTableOrderingComposer,
      $$DeclensionsTableTableAnnotationComposer,
      $$DeclensionsTableTableCreateCompanionBuilder,
      $$DeclensionsTableTableUpdateCompanionBuilder,
      (
        DeclensionEntry,
        BaseReferences<_$AppDatabase, $DeclensionsTableTable, DeclensionEntry>,
      ),
      DeclensionEntry,
      PrefetchHooks Function()
    >;
typedef $$GrammarLessonsTableTableCreateCompanionBuilder =
    GrammarLessonsTableCompanion Function({
      Value<int> id,
      required int langId,
      required String slug,
      required String level,
      Value<int> orderIndex,
      Value<String> titleJson,
      Value<String> prerequisiteIdsJson,
      Value<String> linkedVerbIdsJson,
      Value<String> targetTensesJson,
      Value<String> linkedDeclensionIdsJson,
      Value<String> targetCasesJson,
      Value<String> blocksJson,
      Value<String> exercisesJson,
      Value<bool> isPublished,
    });
typedef $$GrammarLessonsTableTableUpdateCompanionBuilder =
    GrammarLessonsTableCompanion Function({
      Value<int> id,
      Value<int> langId,
      Value<String> slug,
      Value<String> level,
      Value<int> orderIndex,
      Value<String> titleJson,
      Value<String> prerequisiteIdsJson,
      Value<String> linkedVerbIdsJson,
      Value<String> targetTensesJson,
      Value<String> linkedDeclensionIdsJson,
      Value<String> targetCasesJson,
      Value<String> blocksJson,
      Value<String> exercisesJson,
      Value<bool> isPublished,
    });

class $$GrammarLessonsTableTableFilterComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTableTable> {
  $$GrammarLessonsTableTableFilterComposer({
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

  ColumnFilters<int> get langId => $composableBuilder(
    column: $table.langId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get titleJson => $composableBuilder(
    column: $table.titleJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get prerequisiteIdsJson => $composableBuilder(
    column: $table.prerequisiteIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedVerbIdsJson => $composableBuilder(
    column: $table.linkedVerbIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetTensesJson => $composableBuilder(
    column: $table.targetTensesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedDeclensionIdsJson => $composableBuilder(
    column: $table.linkedDeclensionIdsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get targetCasesJson => $composableBuilder(
    column: $table.targetCasesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get blocksJson => $composableBuilder(
    column: $table.blocksJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exercisesJson => $composableBuilder(
    column: $table.exercisesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GrammarLessonsTableTableOrderingComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTableTable> {
  $$GrammarLessonsTableTableOrderingComposer({
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

  ColumnOrderings<int> get langId => $composableBuilder(
    column: $table.langId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get titleJson => $composableBuilder(
    column: $table.titleJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get prerequisiteIdsJson => $composableBuilder(
    column: $table.prerequisiteIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedVerbIdsJson => $composableBuilder(
    column: $table.linkedVerbIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetTensesJson => $composableBuilder(
    column: $table.targetTensesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedDeclensionIdsJson => $composableBuilder(
    column: $table.linkedDeclensionIdsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get targetCasesJson => $composableBuilder(
    column: $table.targetCasesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get blocksJson => $composableBuilder(
    column: $table.blocksJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exercisesJson => $composableBuilder(
    column: $table.exercisesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GrammarLessonsTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $GrammarLessonsTableTable> {
  $$GrammarLessonsTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get langId =>
      $composableBuilder(column: $table.langId, builder: (column) => column);

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get orderIndex => $composableBuilder(
    column: $table.orderIndex,
    builder: (column) => column,
  );

  GeneratedColumn<String> get titleJson =>
      $composableBuilder(column: $table.titleJson, builder: (column) => column);

  GeneratedColumn<String> get prerequisiteIdsJson => $composableBuilder(
    column: $table.prerequisiteIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedVerbIdsJson => $composableBuilder(
    column: $table.linkedVerbIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetTensesJson => $composableBuilder(
    column: $table.targetTensesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get linkedDeclensionIdsJson => $composableBuilder(
    column: $table.linkedDeclensionIdsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get targetCasesJson => $composableBuilder(
    column: $table.targetCasesJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get blocksJson => $composableBuilder(
    column: $table.blocksJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get exercisesJson => $composableBuilder(
    column: $table.exercisesJson,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPublished => $composableBuilder(
    column: $table.isPublished,
    builder: (column) => column,
  );
}

class $$GrammarLessonsTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GrammarLessonsTableTable,
          GrammarLessonEntry,
          $$GrammarLessonsTableTableFilterComposer,
          $$GrammarLessonsTableTableOrderingComposer,
          $$GrammarLessonsTableTableAnnotationComposer,
          $$GrammarLessonsTableTableCreateCompanionBuilder,
          $$GrammarLessonsTableTableUpdateCompanionBuilder,
          (
            GrammarLessonEntry,
            BaseReferences<
              _$AppDatabase,
              $GrammarLessonsTableTable,
              GrammarLessonEntry
            >,
          ),
          GrammarLessonEntry,
          PrefetchHooks Function()
        > {
  $$GrammarLessonsTableTableTableManager(
    _$AppDatabase db,
    $GrammarLessonsTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GrammarLessonsTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GrammarLessonsTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$GrammarLessonsTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> langId = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<int> orderIndex = const Value.absent(),
                Value<String> titleJson = const Value.absent(),
                Value<String> prerequisiteIdsJson = const Value.absent(),
                Value<String> linkedVerbIdsJson = const Value.absent(),
                Value<String> targetTensesJson = const Value.absent(),
                Value<String> linkedDeclensionIdsJson = const Value.absent(),
                Value<String> targetCasesJson = const Value.absent(),
                Value<String> blocksJson = const Value.absent(),
                Value<String> exercisesJson = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
              }) => GrammarLessonsTableCompanion(
                id: id,
                langId: langId,
                slug: slug,
                level: level,
                orderIndex: orderIndex,
                titleJson: titleJson,
                prerequisiteIdsJson: prerequisiteIdsJson,
                linkedVerbIdsJson: linkedVerbIdsJson,
                targetTensesJson: targetTensesJson,
                linkedDeclensionIdsJson: linkedDeclensionIdsJson,
                targetCasesJson: targetCasesJson,
                blocksJson: blocksJson,
                exercisesJson: exercisesJson,
                isPublished: isPublished,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int langId,
                required String slug,
                required String level,
                Value<int> orderIndex = const Value.absent(),
                Value<String> titleJson = const Value.absent(),
                Value<String> prerequisiteIdsJson = const Value.absent(),
                Value<String> linkedVerbIdsJson = const Value.absent(),
                Value<String> targetTensesJson = const Value.absent(),
                Value<String> linkedDeclensionIdsJson = const Value.absent(),
                Value<String> targetCasesJson = const Value.absent(),
                Value<String> blocksJson = const Value.absent(),
                Value<String> exercisesJson = const Value.absent(),
                Value<bool> isPublished = const Value.absent(),
              }) => GrammarLessonsTableCompanion.insert(
                id: id,
                langId: langId,
                slug: slug,
                level: level,
                orderIndex: orderIndex,
                titleJson: titleJson,
                prerequisiteIdsJson: prerequisiteIdsJson,
                linkedVerbIdsJson: linkedVerbIdsJson,
                targetTensesJson: targetTensesJson,
                linkedDeclensionIdsJson: linkedDeclensionIdsJson,
                targetCasesJson: targetCasesJson,
                blocksJson: blocksJson,
                exercisesJson: exercisesJson,
                isPublished: isPublished,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GrammarLessonsTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GrammarLessonsTableTable,
      GrammarLessonEntry,
      $$GrammarLessonsTableTableFilterComposer,
      $$GrammarLessonsTableTableOrderingComposer,
      $$GrammarLessonsTableTableAnnotationComposer,
      $$GrammarLessonsTableTableCreateCompanionBuilder,
      $$GrammarLessonsTableTableUpdateCompanionBuilder,
      (
        GrammarLessonEntry,
        BaseReferences<
          _$AppDatabase,
          $GrammarLessonsTableTable,
          GrammarLessonEntry
        >,
      ),
      GrammarLessonEntry,
      PrefetchHooks Function()
    >;
typedef $$LessonProgressTableTableCreateCompanionBuilder =
    LessonProgressTableCompanion Function({
      Value<int> id,
      Value<String> userKey,
      required int lessonId,
      Value<String> exerciseResultsJson,
      Value<double> score,
      Value<DateTime> lastSeenAt,
      Value<DateTime?> nextDueAt,
    });
typedef $$LessonProgressTableTableUpdateCompanionBuilder =
    LessonProgressTableCompanion Function({
      Value<int> id,
      Value<String> userKey,
      Value<int> lessonId,
      Value<String> exerciseResultsJson,
      Value<double> score,
      Value<DateTime> lastSeenAt,
      Value<DateTime?> nextDueAt,
    });

class $$LessonProgressTableTableFilterComposer
    extends Composer<_$AppDatabase, $LessonProgressTableTable> {
  $$LessonProgressTableTableFilterComposer({
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

  ColumnFilters<String> get userKey => $composableBuilder(
    column: $table.userKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get exerciseResultsJson => $composableBuilder(
    column: $table.exerciseResultsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextDueAt => $composableBuilder(
    column: $table.nextDueAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LessonProgressTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LessonProgressTableTable> {
  $$LessonProgressTableTableOrderingComposer({
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

  ColumnOrderings<String> get userKey => $composableBuilder(
    column: $table.userKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lessonId => $composableBuilder(
    column: $table.lessonId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get exerciseResultsJson => $composableBuilder(
    column: $table.exerciseResultsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get score => $composableBuilder(
    column: $table.score,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextDueAt => $composableBuilder(
    column: $table.nextDueAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LessonProgressTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LessonProgressTableTable> {
  $$LessonProgressTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userKey =>
      $composableBuilder(column: $table.userKey, builder: (column) => column);

  GeneratedColumn<int> get lessonId =>
      $composableBuilder(column: $table.lessonId, builder: (column) => column);

  GeneratedColumn<String> get exerciseResultsJson => $composableBuilder(
    column: $table.exerciseResultsJson,
    builder: (column) => column,
  );

  GeneratedColumn<double> get score =>
      $composableBuilder(column: $table.score, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSeenAt => $composableBuilder(
    column: $table.lastSeenAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get nextDueAt =>
      $composableBuilder(column: $table.nextDueAt, builder: (column) => column);
}

class $$LessonProgressTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LessonProgressTableTable,
          LessonProgressEntry,
          $$LessonProgressTableTableFilterComposer,
          $$LessonProgressTableTableOrderingComposer,
          $$LessonProgressTableTableAnnotationComposer,
          $$LessonProgressTableTableCreateCompanionBuilder,
          $$LessonProgressTableTableUpdateCompanionBuilder,
          (
            LessonProgressEntry,
            BaseReferences<
              _$AppDatabase,
              $LessonProgressTableTable,
              LessonProgressEntry
            >,
          ),
          LessonProgressEntry,
          PrefetchHooks Function()
        > {
  $$LessonProgressTableTableTableManager(
    _$AppDatabase db,
    $LessonProgressTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LessonProgressTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LessonProgressTableTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$LessonProgressTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userKey = const Value.absent(),
                Value<int> lessonId = const Value.absent(),
                Value<String> exerciseResultsJson = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<DateTime?> nextDueAt = const Value.absent(),
              }) => LessonProgressTableCompanion(
                id: id,
                userKey: userKey,
                lessonId: lessonId,
                exerciseResultsJson: exerciseResultsJson,
                score: score,
                lastSeenAt: lastSeenAt,
                nextDueAt: nextDueAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> userKey = const Value.absent(),
                required int lessonId,
                Value<String> exerciseResultsJson = const Value.absent(),
                Value<double> score = const Value.absent(),
                Value<DateTime> lastSeenAt = const Value.absent(),
                Value<DateTime?> nextDueAt = const Value.absent(),
              }) => LessonProgressTableCompanion.insert(
                id: id,
                userKey: userKey,
                lessonId: lessonId,
                exerciseResultsJson: exerciseResultsJson,
                score: score,
                lastSeenAt: lastSeenAt,
                nextDueAt: nextDueAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LessonProgressTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LessonProgressTableTable,
      LessonProgressEntry,
      $$LessonProgressTableTableFilterComposer,
      $$LessonProgressTableTableOrderingComposer,
      $$LessonProgressTableTableAnnotationComposer,
      $$LessonProgressTableTableCreateCompanionBuilder,
      $$LessonProgressTableTableUpdateCompanionBuilder,
      (
        LessonProgressEntry,
        BaseReferences<
          _$AppDatabase,
          $LessonProgressTableTable,
          LessonProgressEntry
        >,
      ),
      LessonProgressEntry,
      PrefetchHooks Function()
    >;
typedef $$LevelCoverageTableTableCreateCompanionBuilder =
    LevelCoverageTableCompanion Function({
      required String language,
      required String level,
      required int wordCount,
      required int quota,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$LevelCoverageTableTableUpdateCompanionBuilder =
    LevelCoverageTableCompanion Function({
      Value<String> language,
      Value<String> level,
      Value<int> wordCount,
      Value<int> quota,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$LevelCoverageTableTableFilterComposer
    extends Composer<_$AppDatabase, $LevelCoverageTableTable> {
  $$LevelCoverageTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quota => $composableBuilder(
    column: $table.quota,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LevelCoverageTableTableOrderingComposer
    extends Composer<_$AppDatabase, $LevelCoverageTableTable> {
  $$LevelCoverageTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wordCount => $composableBuilder(
    column: $table.wordCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quota => $composableBuilder(
    column: $table.quota,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LevelCoverageTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $LevelCoverageTableTable> {
  $$LevelCoverageTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get wordCount =>
      $composableBuilder(column: $table.wordCount, builder: (column) => column);

  GeneratedColumn<int> get quota =>
      $composableBuilder(column: $table.quota, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$LevelCoverageTableTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LevelCoverageTableTable,
          LevelCoverageEntry,
          $$LevelCoverageTableTableFilterComposer,
          $$LevelCoverageTableTableOrderingComposer,
          $$LevelCoverageTableTableAnnotationComposer,
          $$LevelCoverageTableTableCreateCompanionBuilder,
          $$LevelCoverageTableTableUpdateCompanionBuilder,
          (
            LevelCoverageEntry,
            BaseReferences<
              _$AppDatabase,
              $LevelCoverageTableTable,
              LevelCoverageEntry
            >,
          ),
          LevelCoverageEntry,
          PrefetchHooks Function()
        > {
  $$LevelCoverageTableTableTableManager(
    _$AppDatabase db,
    $LevelCoverageTableTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LevelCoverageTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LevelCoverageTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LevelCoverageTableTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> language = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<int> wordCount = const Value.absent(),
                Value<int> quota = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelCoverageTableCompanion(
                language: language,
                level: level,
                wordCount: wordCount,
                quota: quota,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String language,
                required String level,
                required int wordCount,
                required int quota,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LevelCoverageTableCompanion.insert(
                language: language,
                level: level,
                wordCount: wordCount,
                quota: quota,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LevelCoverageTableTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LevelCoverageTableTable,
      LevelCoverageEntry,
      $$LevelCoverageTableTableFilterComposer,
      $$LevelCoverageTableTableOrderingComposer,
      $$LevelCoverageTableTableAnnotationComposer,
      $$LevelCoverageTableTableCreateCompanionBuilder,
      $$LevelCoverageTableTableUpdateCompanionBuilder,
      (
        LevelCoverageEntry,
        BaseReferences<
          _$AppDatabase,
          $LevelCoverageTableTable,
          LevelCoverageEntry
        >,
      ),
      LevelCoverageEntry,
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
  $$LanguagesTableTableTableManager get languagesTable =>
      $$LanguagesTableTableTableManager(_db, _db.languagesTable);
  $$ConjugationsTableTableTableManager get conjugationsTable =>
      $$ConjugationsTableTableTableManager(_db, _db.conjugationsTable);
  $$DeclensionsTableTableTableManager get declensionsTable =>
      $$DeclensionsTableTableTableManager(_db, _db.declensionsTable);
  $$GrammarLessonsTableTableTableManager get grammarLessonsTable =>
      $$GrammarLessonsTableTableTableManager(_db, _db.grammarLessonsTable);
  $$LessonProgressTableTableTableManager get lessonProgressTable =>
      $$LessonProgressTableTableTableManager(_db, _db.lessonProgressTable);
  $$LevelCoverageTableTableTableManager get levelCoverageTable =>
      $$LevelCoverageTableTableTableManager(_db, _db.levelCoverageTable);
}
