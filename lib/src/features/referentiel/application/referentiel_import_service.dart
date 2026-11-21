import 'dart:convert';
import '../data/drift_referentiel_repository.dart';
import '../domain/bundle_validator.dart';
import '../domain/conjugation.dart';
import '../domain/declension.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_profile.dart';
import '../domain/text_normalizer.dart';

class ImportReport {
  final bool success;
  final List<ValidationIssue> errors;
  final List<ValidationIssue> warnings;
  final int upsertedConjugations;
  final int upsertedDeclensions;
  final int upsertedLessons;
  final List<String> createdSkeletons;
  final List<String> unpublishedRecords;

  const ImportReport({
    required this.success,
    this.errors = const [],
    this.warnings = const [],
    this.upsertedConjugations = 0,
    this.upsertedDeclensions = 0,
    this.upsertedLessons = 0,
    this.createdSkeletons = const [],
    this.unpublishedRecords = const [],
  });
}

class ReferentielImportService {
  final DriftReferentielRepository repo;

  ReferentielImportService(this.repo);

  Future<ImportReport> importBundleJsonString(
    String rawJson, {
    required LanguageRecord targetLanguage,
  }) async {
    final dynamic decoded;
    try {
      decoded = jsonDecode(rawJson);
    } catch (e) {
      return ImportReport(
        success: false,
        errors: [ValidationIssue(entity: 'json', message: 'JSON invalide : $e')],
      );
    }

    if (decoded is! Map) {
      return const ImportReport(
        success: false,
        errors: [ValidationIssue(entity: 'json', message: 'Le bundle racine doit être un objet JSON.')],
      );
    }

    return importBundle(
      Map<String, dynamic>.from(decoded),
      targetLanguage: targetLanguage,
    );
  }

  Future<ImportReport> importBundle(
    Map<String, dynamic> bundle, {
    required LanguageRecord targetLanguage,
  }) async {
    final profile = targetLanguage.grammarProfile;

    // Charger le graphe existant des leçons pour détection globale des cycles
    final existingLessons = await repo.getLessons(targetLanguage.id, publishedOnly: false);
    final slugById = {for (final l in existingLessons) l.id: l.slug};
    final existingPrereqSlugs = <String, List<String>>{
      for (final l in existingLessons)
        l.slug: l.prerequisiteIds.map((id) => slugById[id]).whereType<String>().toList(),
    };

    final validation = BundleValidator.validateBundle(
      bundle: bundle,
      language: targetLanguage,
      existingPrerequisiteSlugsBySlug: existingPrereqSlugs,
    );

    if (!validation.isValid) {
      return ImportReport(
        success: false,
        errors: validation.errors,
        warnings: validation.warnings,
      );
    }

    final unpublished = <String>[];
    final skeletons = <String>[];

    // 1. Upsert conjugations (toujours is_published: false après import)
    final verbIdByLemma = <String, int>{
      for (final c in await repo.getConjugations(targetLanguage.id, publishedOnly: false))
        c.lemma: c.id,
    };
    var conjCount = 0;
    for (final raw in (bundle['conjugations'] as List? ?? const [])) {
      final map = Map<String, dynamic>.from(raw as Map);
      final lemma = TextNormalizer.normalize(map['lemma'] as String);
      final prev = await repo.findConjugationByLemma(targetLanguage.id, lemma);
      if (prev != null && prev.isPublished) {
        unpublished.add('conjugation:$lemma');
      }

      final forms = (map['forms'] as List? ?? const [])
          .map((e) => ConjugationForm.fromJson(Map<String, dynamic>.from(e as Map)).normalized())
          .toList();

      final saved = await repo.upsertConjugation(
        ConjugationRecord(
          langId: targetLanguage.id,
          langCode: targetLanguage.code,
          lemma: lemma,
          group: profile.hasVerbGroups ? map['group'] as String? : null,
          auxiliaries: profile.hasAuxiliaries
              ? List<String>.from(map['auxiliaries'] as List? ?? const [])
                  .map(TextNormalizer.normalize)
                  .toList()
              : const [],
          isPronominal: profile.hasPronominalVerbs && ((map['is_pronominal'] as bool?) ?? false),
          reflexiveCase: profile.hasPronominalVerbs ? map['reflexive_case'] as String? : null,
          isIrregular: (map['is_irregular'] as bool?) ?? false,
          isDefective: (map['is_defective'] as bool?) ?? false,
          generalNote: Map<String, String>.from(map['general_note'] as Map? ?? const {}),
          forms: forms,
          source: (map['source'] as String?) ?? 'ai',
          isPublished: false,
        ),
      );
      verbIdByLemma[saved.lemma] = saved.id;
      conjCount++;
    }

    // 2. Upsert declensions (toujours is_published: false après import)
    final declIdByKey = <String, int>{
      for (final d in await repo.getDeclensions(targetLanguage.id, publishedOnly: false))
        d.compositeKey: d.id,
    };
    var declCount = 0;
    for (final raw in (bundle['declensions'] as List? ?? const [])) {
      final map = Map<String, dynamic>.from(raw as Map);
      final lemma = TextNormalizer.normalize(map['lemma'] as String);
      final pos = DeclensionPos.tryParse(map['pos'] as String)!;
      final prev = await repo.findDeclensionByLemmaPos(targetLanguage.id, lemma, pos);
      if (prev != null && prev.isPublished) {
        unpublished.add('declension:${prev.compositeKey}');
      }

      final forms = (map['forms'] as List? ?? const [])
          .map((e) => DeclensionForm.fromJson(Map<String, dynamic>.from(e as Map)).normalized())
          .toList();

      final saved = await repo.upsertDeclension(
        DeclensionRecord(
          langId: targetLanguage.id,
          langCode: targetLanguage.code,
          lemma: lemma,
          pos: pos,
          gender: pos == DeclensionPos.noun ? map['gender'] as String? : null,
          declensionClass:
              pos == DeclensionPos.noun && profile.hasDeclensionClasses
                  ? map['declension_class'] as String?
                  : null,
          isIrregular: (map['is_irregular'] as bool?) ?? false,
          isInvariable: (map['is_invariable'] as bool?) ?? false,
          generalNote: Map<String, String>.from(map['general_note'] as Map? ?? const {}),
          forms: forms,
          source: (map['source'] as String?) ?? 'ai',
          isPublished: false,
        ),
      );
      declIdByKey[saved.compositeKey] = saved.id;
      declCount++;
    }

    // 3. Upsert lessons + création de squelettes si besoin
    final rawLessons = (bundle['lessons'] as List? ?? const [])
        .map((e) => Map<String, dynamic>.from(e as Map))
        .toList();

    // Passe 1 : garantir existence des slugs pour résoudre prerequisites
    final lessonIdBySlug = <String, int>{
      for (final l in existingLessons) l.slug: l.id,
    };
    for (final map in rawLessons) {
      final slug = (map['slug'] as String).trim();
      if (!lessonIdBySlug.containsKey(slug)) {
        final created = await repo.upsertLesson(
          GrammarLessonRecord(
            langId: targetLanguage.id,
            langCode: targetLanguage.code,
            slug: slug,
            level: (map['level'] as String).toUpperCase(),
            order: (map['order'] as int?) ?? 1,
            title: Map<String, String>.from(map['title'] as Map? ?? const {}),
            isPublished: false,
          ),
        );
        lessonIdBySlug[slug] = created.id;
      }
    }

    var lessonCount = 0;
    for (final map in rawLessons) {
      final slug = (map['slug'] as String).trim();
      final prev = existingLessons.where((l) => l.slug == slug).firstOrNull;
      if (prev != null && prev.isPublished) {
        unpublished.add('lesson:$slug');
      }

      // Résoudre linked_verbs (créer squelette si absent)
      final linkedVerbIds = <int>[];
      for (final rawLemma in (map['linked_verbs'] as List? ?? const [])) {
        final lemma = TextNormalizer.normalize(rawLemma.toString());
        var id = verbIdByLemma[lemma];
        if (id == null) {
          final skel = await repo.upsertConjugation(
            ConjugationRecord(
              langId: targetLanguage.id,
              langCode: targetLanguage.code,
              lemma: lemma,
              forms: const [],
              source: 'ai',
              isPublished: false,
            ),
          );
          id = skel.id;
          verbIdByLemma[lemma] = id;
          skeletons.add('conjugation:$lemma');
        }
        linkedVerbIds.add(id);
      }

      // Résoudre linked_declensions "<lemma>#<POS>" (créer squelette si absent)
      final linkedDeclIds = <int>[];
      for (final rawRef in (map['linked_declensions'] as List? ?? const [])) {
        final refStr = TextNormalizer.normalize(rawRef.toString());
        final hashIdx = refStr.lastIndexOf('#');
        final lemma = refStr.substring(0, hashIdx);
        final pos = DeclensionPos.tryParse(refStr.substring(hashIdx + 1))!;
        final key = '$lemma#${pos.code}';
        var id = declIdByKey[key];
        if (id == null) {
          final skel = await repo.upsertDeclension(
            DeclensionRecord(
              langId: targetLanguage.id,
              langCode: targetLanguage.code,
              lemma: lemma,
              pos: pos,
              forms: const [],
              source: 'ai',
              isPublished: false,
            ),
          );
          id = skel.id;
          declIdByKey[key] = id;
          skeletons.add('declension:$key');
        }
        linkedDeclIds.add(id);
      }

      final prereqIds = (map['prerequisites'] as List? ?? const [])
          .map((s) => lessonIdBySlug[s.toString().trim()])
          .whereType<int>()
          .toList();

      final targetTenses = (map['target_tenses'] as List? ?? const [])
          .map((e) => TargetTense.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      final targetCases = List<String>.from(map['target_cases'] as List? ?? const []);
      final blocks = (map['blocks'] as List? ?? const [])
          .map((e) => LessonBlock.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      final exercises = (map['exercises'] as List? ?? const [])
          .map((e) => LessonExercise.fromJson(Map<String, dynamic>.from(e as Map)).normalized())
          .toList();

      await repo.upsertLesson(
        GrammarLessonRecord(
          langId: targetLanguage.id,
          langCode: targetLanguage.code,
          slug: slug,
          level: (map['level'] as String).toUpperCase(),
          order: (map['order'] as int?) ?? 1,
          title: Map<String, String>.from(map['title'] as Map? ?? const {}),
          prerequisiteIds: prereqIds,
          linkedVerbIds: linkedVerbIds,
          targetTenses: targetTenses,
          linkedDeclensionIds: linkedDeclIds,
          targetCases: targetCases,
          blocks: blocks,
          exercises: exercises,
          isPublished: false,
        ),
      );
      lessonCount++;
    }

    return ImportReport(
      success: true,
      warnings: validation.warnings,
      upsertedConjugations: conjCount,
      upsertedDeclensions: declCount,
      upsertedLessons: lessonCount,
      createdSkeletons: skeletons,
      unpublishedRecords: unpublished,
    );
  }
}
