import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/conjugation.dart';
import '../domain/declension.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_profile.dart';
import '../domain/text_normalizer.dart';
import 'referentiel_mappers.dart';

class DriftReferentielRepository {
  final AppDatabase db;

  DriftReferentielRepository(this.db);

  Future<List<LanguageRecord>> getLanguages() async {
    final rows = await db.select(db.languagesTable).get();
    return rows.map((r) => r.toDomain()).toList();
  }

  Future<LanguageRecord?> getLanguageByCode(String code) async {
    final query = db.select(db.languagesTable)
      ..where((t) => t.code.equals(code.trim().toLowerCase()));
    final row = await query.getSingleOrNull();
    return row?.toDomain();
  }

  Future<LanguageRecord?> getLanguageById(int id) async {
    final query = db.select(db.languagesTable)..where((t) => t.id.equals(id));
    final row = await query.getSingleOrNull();
    return row?.toDomain();
  }

  // --- Conjugations ---

  Future<List<ConjugationRecord>> getConjugations(
    int langId, {
    bool publishedOnly = true,
  }) async {
    final lang = await getLanguageById(langId);
    if (lang == null) return [];
    final query = db.select(db.conjugationsTable)
      ..where((t) => publishedOnly
          ? (t.langId.equals(langId) & t.isPublished.equals(true))
          : t.langId.equals(langId))
      ..orderBy([(t) => OrderingTerm.asc(t.lemma)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain(lang.code)).toList();
  }

  Future<ConjugationRecord?> getConjugationById(int id) async {
    final row = await (db.select(db.conjugationsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    final lang = await getLanguageById(row.langId);
    return row.toDomain(lang?.code ?? '');
  }

  Future<ConjugationRecord?> findConjugationByLemma(int langId, String lemma) async {
    final lang = await getLanguageById(langId);
    if (lang == null) return null;
    final normLemma = TextNormalizer.normalize(lemma);
    final row = await (db.select(db.conjugationsTable)
          ..where((t) => t.langId.equals(langId) & t.lemma.equals(normLemma)))
        .getSingleOrNull();
    return row?.toDomain(lang.code);
  }

  Future<ConjugationRecord> upsertConjugation(ConjugationRecord record) async {
    final normLemma = TextNormalizer.normalize(record.lemma);
    final normForms = record.forms.map((f) => f.normalized()).toList();
    final effectivePublished =
        normForms.any((f) => f.needsReview) ? false : record.isPublished;

    final existing = await (db.select(db.conjugationsTable)
          ..where((t) => t.langId.equals(record.langId) & t.lemma.equals(normLemma)))
        .getSingleOrNull();

    final companion = ConjugationsTableCompanion(
      langId: Value(record.langId),
      lemma: Value(normLemma),
      verbGroup: Value(record.group),
      auxiliariesJson: Value(jsonEncode(record.auxiliaries)),
      isPronominal: Value(record.isPronominal),
      reflexiveCase: Value(record.reflexiveCase),
      isIrregular: Value(record.isIrregular),
      isDefective: Value(record.isDefective),
      generalNoteJson: Value(jsonEncode(record.generalNote)),
      formsJson: Value(jsonEncode(normForms.map((f) => f.toJson()).toList())),
      source: Value(record.source),
      isPublished: Value(effectivePublished),
    );

    if (existing != null) {
      await (db.update(db.conjugationsTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(companion);
      return (await getConjugationById(existing.id))!;
    } else {
      final newId = await db.into(db.conjugationsTable).insert(companion);
      return (await getConjugationById(newId))!;
    }
  }

  Future<void> deleteConjugation(int id) async {
    await (db.delete(db.conjugationsTable)..where((t) => t.id.equals(id))).go();
  }

  // --- Declensions ---

  Future<List<DeclensionRecord>> getDeclensions(
    int langId, {
    bool publishedOnly = true,
  }) async {
    final lang = await getLanguageById(langId);
    if (lang == null) return [];
    final query = db.select(db.declensionsTable)
      ..where((t) => publishedOnly
          ? (t.langId.equals(langId) & t.isPublished.equals(true))
          : t.langId.equals(langId))
      ..orderBy([(t) => OrderingTerm.asc(t.lemma)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain(lang.code)).toList();
  }

  Future<DeclensionRecord?> getDeclensionById(int id) async {
    final row = await (db.select(db.declensionsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    final lang = await getLanguageById(row.langId);
    return row.toDomain(lang?.code ?? '');
  }

  Future<DeclensionRecord?> findDeclensionByLemmaPos(
    int langId,
    String lemma,
    DeclensionPos pos,
  ) async {
    final lang = await getLanguageById(langId);
    if (lang == null) return null;
    final normLemma = TextNormalizer.normalize(lemma);
    final row = await (db.select(db.declensionsTable)
          ..where((t) =>
              t.langId.equals(langId) &
              t.lemma.equals(normLemma) &
              t.pos.equals(pos.code)))
        .getSingleOrNull();
    return row?.toDomain(lang.code);
  }

  Future<DeclensionRecord> upsertDeclension(DeclensionRecord record) async {
    final normLemma = TextNormalizer.normalize(record.lemma);
    final normForms = record.forms.map((f) => f.normalized()).toList();
    final effectivePublished =
        normForms.any((f) => f.needsReview) ? false : record.isPublished;
    final effectiveDeclClass =
        record.pos == DeclensionPos.noun ? record.declensionClass : null;
    final effectiveGender =
        record.pos == DeclensionPos.noun ? record.gender : null;

    final existing = await (db.select(db.declensionsTable)
          ..where((t) =>
              t.langId.equals(record.langId) &
              t.lemma.equals(normLemma) &
              t.pos.equals(record.pos.code)))
        .getSingleOrNull();

    final companion = DeclensionsTableCompanion(
      langId: Value(record.langId),
      lemma: Value(normLemma),
      pos: Value(record.pos.code),
      gender: Value(effectiveGender),
      declensionClass: Value(effectiveDeclClass),
      isIrregular: Value(record.isIrregular),
      isInvariable: Value(record.isInvariable),
      generalNoteJson: Value(jsonEncode(record.generalNote)),
      formsJson: Value(jsonEncode(normForms.map((f) => f.toJson()).toList())),
      source: Value(record.source),
      isPublished: Value(effectivePublished),
    );

    if (existing != null) {
      await (db.update(db.declensionsTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(companion);
      return (await getDeclensionById(existing.id))!;
    } else {
      final newId = await db.into(db.declensionsTable).insert(companion);
      return (await getDeclensionById(newId))!;
    }
  }

  Future<void> deleteDeclension(int id) async {
    await (db.delete(db.declensionsTable)..where((t) => t.id.equals(id))).go();
  }

  // --- Grammar Lessons ---

  Future<List<GrammarLessonRecord>> getLessons(
    int langId, {
    bool publishedOnly = true,
  }) async {
    final lang = await getLanguageById(langId);
    if (lang == null) return [];
    final query = db.select(db.grammarLessonsTable)
      ..where((t) => publishedOnly
          ? (t.langId.equals(langId) & t.isPublished.equals(true))
          : t.langId.equals(langId))
      ..orderBy([(t) => OrderingTerm.asc(t.orderIndex)]);
    final rows = await query.get();
    return rows.map((r) => r.toDomain(lang.code)).toList();
  }

  Future<GrammarLessonRecord?> getLessonById(int id) async {
    final row = await (db.select(db.grammarLessonsTable)
          ..where((t) => t.id.equals(id)))
        .getSingleOrNull();
    if (row == null) return null;
    final lang = await getLanguageById(row.langId);
    return row.toDomain(lang?.code ?? '');
  }

  Future<GrammarLessonRecord?> findLessonBySlug(int langId, String slug) async {
    final lang = await getLanguageById(langId);
    if (lang == null) return null;
    final row = await (db.select(db.grammarLessonsTable)
          ..where((t) => t.langId.equals(langId) & t.slug.equals(slug.trim())))
        .getSingleOrNull();
    return row?.toDomain(lang.code);
  }

  Future<GrammarLessonRecord> upsertLesson(GrammarLessonRecord record) async {
    final slug = record.slug.trim();
    final normExercises = record.exercises.map((e) => e.normalized()).toList();
    final existing = await (db.select(db.grammarLessonsTable)
          ..where((t) => t.langId.equals(record.langId) & t.slug.equals(slug)))
        .getSingleOrNull();

    final companion = GrammarLessonsTableCompanion(
      langId: Value(record.langId),
      slug: Value(slug),
      level: Value(record.level.toUpperCase()),
      orderIndex: Value(record.order),
      titleJson: Value(jsonEncode(record.title)),
      prerequisiteIdsJson: Value(jsonEncode(record.prerequisiteIds)),
      linkedVerbIdsJson: Value(jsonEncode(record.linkedVerbIds)),
      targetTensesJson: Value(jsonEncode(record.targetTenses.map((t) => t.toJson()).toList())),
      linkedDeclensionIdsJson: Value(jsonEncode(record.linkedDeclensionIds)),
      targetCasesJson: Value(jsonEncode(record.targetCases)),
      blocksJson: Value(jsonEncode(record.blocks.map((b) => b.toJson()).toList())),
      exercisesJson: Value(jsonEncode(normExercises.map((e) => e.toJson()).toList())),
      isPublished: Value(record.isPublished),
    );

    if (existing != null) {
      await (db.update(db.grammarLessonsTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(companion);
      return (await getLessonById(existing.id))!;
    } else {
      final newId = await db.into(db.grammarLessonsTable).insert(companion);
      return (await getLessonById(newId))!;
    }
  }

  Future<void> deleteLesson(int id) async {
    await (db.delete(db.grammarLessonsTable)..where((t) => t.id.equals(id))).go();
  }

  // --- Lesson Progress ---

  Future<LessonProgressRecord?> getLessonProgress(
    int lessonId, {
    String userKey = 'local',
  }) async {
    final row = await (db.select(db.lessonProgressTable)
          ..where((t) => t.userKey.equals(userKey) & t.lessonId.equals(lessonId)))
        .getSingleOrNull();
    return row?.toDomain();
  }

  Future<Map<int, LessonProgressRecord>> getAllLessonProgress({
    String userKey = 'local',
  }) async {
    final rows = await (db.select(db.lessonProgressTable)
          ..where((t) => t.userKey.equals(userKey)))
        .get();
    return {for (final r in rows) r.lessonId: r.toDomain()};
  }

  Future<LessonProgressRecord> saveLessonSessionResult({
    required int lessonId,
    required Map<String, ExerciseResult> newResults,
    required int totalCount,
    DateTime? now,
    String userKey = 'local',
  }) async {
    final timestamp = now ?? DateTime.now();
    final existing = await getLessonProgress(lessonId, userKey: userKey);
    final merged = <String, ExerciseResult>{
      ...?existing?.exerciseResults,
    };

    for (final entry in newResults.entries) {
      final prev = merged[entry.key];
      merged[entry.key] = ExerciseResult(
        score: entry.value.score,
        attempts: (prev?.attempts ?? 0) + entry.value.attempts,
        lastAt: entry.value.lastAt,
      );
    }

    final denom = totalCount > 0 ? totalCount : (merged.isNotEmpty ? merged.length : 1);
    final totalScore = merged.values.fold<double>(0, (sum, r) => sum + r.score);
    final normalizedScore = (totalScore / denom).clamp(0.0, 1.0);

    final resultsJson = jsonEncode(merged.map((k, v) => MapEntry(k, v.toJson())));

    if (existing != null) {
      await (db.update(db.lessonProgressTable)
            ..where((t) => t.id.equals(existing.id)))
          .write(LessonProgressTableCompanion(
        exerciseResultsJson: Value(resultsJson),
        score: Value(normalizedScore),
        lastSeenAt: Value(timestamp),
      ));
    } else {
      await db.into(db.lessonProgressTable).insert(
            LessonProgressTableCompanion.insert(
              userKey: Value(userKey),
              lessonId: lessonId,
              exerciseResultsJson: Value(resultsJson),
              score: Value(normalizedScore),
              lastSeenAt: Value(timestamp),
            ),
          );
    }

    return (await getLessonProgress(lessonId, userKey: userKey))!;
  }

  // --- Export Bundle v1.3 ---

  Future<Map<String, dynamic>> exportBundle(
    LanguageRecord language, {
    bool publishedOnly = false,
  }) async {
    final conjugations = await getConjugations(language.id, publishedOnly: publishedOnly);
    final declensions = await getDeclensions(language.id, publishedOnly: publishedOnly);
    final lessons = await getLessons(language.id, publishedOnly: publishedOnly);

    final verbLemmaById = {for (final c in conjugations) c.id: c.lemma};
    final declKeyById = {for (final d in declensions) d.id: d.compositeKey};
    final lessonSlugById = {for (final l in lessons) l.id: l.slug};

    return {
      'schema_version': '1.3',
      'lang': language.code,
      'conjugations': conjugations.map((c) => c.toBundleJson()).toList(),
      'declensions': declensions.map((d) => d.toBundleJson()).toList(),
      'lessons': lessons.map((l) {
        return {
          'lang': language.code,
          'slug': l.slug,
          'level': l.level,
          'order': l.order,
          'is_published': l.isPublished,
          'title': l.title,
          'prerequisites': l.prerequisiteIds
              .map((id) => lessonSlugById[id])
              .whereType<String>()
              .toList(),
          'target_tenses': l.targetTenses.map((t) => t.toJson()).toList(),
          'linked_verbs': l.linkedVerbIds
              .map((id) => verbLemmaById[id])
              .whereType<String>()
              .toList(),
          'target_cases': l.targetCases,
          'linked_declensions': l.linkedDeclensionIds
              .map((id) => declKeyById[id])
              .whereType<String>()
              .toList(),
          'blocks': l.blocks.map((b) => b.toJson()).toList(),
          'exercises': l.exercises.map((e) => e.toJson()).toList(),
        };
      }).toList(),
    };
  }
}
