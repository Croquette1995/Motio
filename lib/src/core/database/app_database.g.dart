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
  final DateTime createdAt;
  const WordEntry({
    required this.id,
    required this.term,
    required this.translation,
    required this.contextSentence,
    required this.category,
    required this.level,
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
    DateTime? createdAt,
  }) => WordEntry(
    id: id ?? this.id,
    term: term ?? this.term,
    translation: translation ?? this.translation,
    contextSentence: contextSentence ?? this.contextSentence,
    category: category ?? this.category,
    level: level ?? this.level,
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
          other.createdAt == this.createdAt);
}

class WordsTableCompanion extends UpdateCompanion<WordEntry> {
  final Value<int> id;
  final Value<String> term;
  final Value<String> translation;
  final Value<String> contextSentence;
  final Value<String> category;
  final Value<String> level;
  final Value<DateTime> createdAt;
  const WordsTableCompanion({
    this.id = const Value.absent(),
    this.term = const Value.absent(),
    this.translation = const Value.absent(),
    this.contextSentence = const Value.absent(),
    this.category = const Value.absent(),
    this.level = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WordsTableCompanion.insert({
    this.id = const Value.absent(),
    required String term,
    required String translation,
    required String contextSentence,
    required String category,
    required String level,
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
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (term != null) 'term': term,
      if (translation != null) 'translation': translation,
      if (contextSentence != null) 'context_sentence': contextSentence,
      if (category != null) 'category': category,
      if (level != null) 'level': level,
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
    Value<DateTime>? createdAt,
  }) {
    return WordsTableCompanion(
      id: id ?? this.id,
      term: term ?? this.term,
      translation: translation ?? this.translation,
      contextSentence: contextSentence ?? this.contextSentence,
      category: category ?? this.category,
      level: level ?? this.level,
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
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'UNIQUE REFERENCES words_table (id) ON DELETE CASCADE',
    ),
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

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WordsTableTable wordsTable = $WordsTableTable(this);
  late final $WordProgressTableTable wordProgressTable =
      $WordProgressTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    wordsTable,
    wordProgressTable,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'words_table',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('word_progress_table', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$WordsTableTableCreateCompanionBuilder = WordsTableCompanion Function({
  Value<int> id,
  required String term,
  required String translation,
  required String contextSentence,
  required String category,
  required String level,
  Value<DateTime> createdAt,
});
typedef $$WordsTableTableUpdateCompanionBuilder = WordsTableCompanion Function({
  Value<int> id,
  Value<String> term,
  Value<String> translation,
  Value<String> contextSentence,
  Value<String> category,
  Value<String> level,
  Value<DateTime> createdAt,
});

final class $$WordsTableTableReferences
    extends BaseReferences<_$AppDatabase, $WordsTableTable, WordEntry> {
  $$WordsTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$WordProgressTableTable, List<WordProgressEntry>>
  _wordProgressTableRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.wordProgressTable,
        aliasName: 'words_table__id__word_progress_table__word_id',
      );

  $$WordProgressTableTableProcessedTableManager get wordProgressTableRefs {
    final manager = $$WordProgressTableTableTableManager(
      $_db,
      $_db.wordProgressTable,
    ).filter((f) => f.wordId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _wordProgressTableRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> wordProgressTableRefs(
    Expression<bool> Function($$WordProgressTableTableFilterComposer f) f,
  ) {
    final $$WordProgressTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.wordProgressTable,
      getReferencedColumn: (t) => t.wordId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordProgressTableTableFilterComposer(
            $db: $db,
            $table: $db.wordProgressTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> wordProgressTableRefs<T extends Object>(
    Expression<T> Function($$WordProgressTableTableAnnotationComposer a) f,
  ) {
    final $$WordProgressTableTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.wordProgressTable,
          getReferencedColumn: (t) => t.wordId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$WordProgressTableTableAnnotationComposer(
                $db: $db,
                $table: $db.wordProgressTable,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
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
          (WordEntry, $$WordsTableTableReferences),
          WordEntry,
          PrefetchHooks Function({bool wordProgressTableRefs})
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
                Value<DateTime> createdAt = const Value.absent(),
              }) => WordsTableCompanion(
                id: id,
                term: term,
                translation: translation,
                contextSentence: contextSentence,
                category: category,
                level: level,
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
                Value<DateTime> createdAt = const Value.absent(),
              }) => WordsTableCompanion.insert(
                id: id,
                term: term,
                translation: translation,
                contextSentence: contextSentence,
                category: category,
                level: level,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WordsTableTable, WordEntry>(table),
                  $$WordsTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordProgressTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (wordProgressTableRefs) db.wordProgressTable,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (wordProgressTableRefs)
                    await $_getPrefetchedData<
                      WordEntry,
                      $WordsTableTable,
                      WordProgressEntry
                    >(
                      currentTable: table,
                      referencedTable: $$WordsTableTableReferences
                          ._wordProgressTableRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$WordsTableTableReferences(
                            db,
                            table,
                            p0,
                          ).wordProgressTableRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.wordId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
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
      (WordEntry, $$WordsTableTableReferences),
      WordEntry,
      PrefetchHooks Function({bool wordProgressTableRefs})
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

final class $$WordProgressTableTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $WordProgressTableTable,
          WordProgressEntry
        > {
  $$WordProgressTableTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WordsTableTable _wordIdTable(_$AppDatabase db) => db.wordsTable
      .createAlias('word_progress_table__word_id__words_table__id');

  $$WordsTableTableProcessedTableManager get wordId {
    final $_column = $_itemColumn<int>('word_id')!;

    final manager = $$WordsTableTableTableManager(
      $_db,
      $_db.wordsTable,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_wordIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

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

  $$WordsTableTableFilterComposer get wordId {
    final $$WordsTableTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.wordsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableTableFilterComposer(
            $db: $db,
            $table: $db.wordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$WordsTableTableOrderingComposer get wordId {
    final $$WordsTableTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.wordsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableTableOrderingComposer(
            $db: $db,
            $table: $db.wordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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

  $$WordsTableTableAnnotationComposer get wordId {
    final $$WordsTableTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.wordId,
      referencedTable: $db.wordsTable,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WordsTableTableAnnotationComposer(
            $db: $db,
            $table: $db.wordsTable,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
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
          (WordProgressEntry, $$WordProgressTableTableReferences),
          WordProgressEntry,
          PrefetchHooks Function({bool wordId})
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
              .map(
                (e) => (
                  e.readTable<$WordProgressTableTable, WordProgressEntry>(
                    table,
                  ),
                  $$WordProgressTableTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({wordId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (wordId) {
                      state = state.withJoin(
                        currentTable: table,
                        currentColumn: table.wordId,
                        referencedTable: $$WordProgressTableTableReferences
                            ._wordIdTable(db),
                        referencedColumn: $$WordProgressTableTableReferences
                            ._wordIdTable(db)
                            .id,
                      ) as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
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
      (WordProgressEntry, $$WordProgressTableTableReferences),
      WordProgressEntry,
      PrefetchHooks Function({bool wordId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableTableManager get wordsTable =>
      $$WordsTableTableTableManager(_db, _db.wordsTable);
  $$WordProgressTableTableTableManager get wordProgressTable =>
      $$WordProgressTableTableTableManager(_db, _db.wordProgressTable);
}
