import 'dart:convert';
import '../../../core/database/app_database.dart';
import '../domain/conjugation.dart';
import '../domain/declension.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_profile.dart';

extension LanguageEntryMapper on LanguageEntry {
  LanguageRecord toDomain() {
    return LanguageRecord(
      id: id,
      code: code,
      nameL10n: Map<String, String>.from(jsonDecode(nameL10nJson) as Map),
      isNonLatin: isNonLatin,
      grammarProfile: GrammarProfile.fromJson(
        Map<String, dynamic>.from(jsonDecode(grammarProfileJson) as Map),
      ),
    );
  }
}

extension ConjugationEntryMapper on ConjugationEntry {
  ConjugationRecord toDomain(String langCode) {
    final auxList = List<String>.from(jsonDecode(auxiliariesJson) as List);
    final noteMap = Map<String, String>.from(jsonDecode(generalNoteJson) as Map);
    final formsList = (jsonDecode(formsJson) as List)
        .map((e) => ConjugationForm.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return ConjugationRecord(
      id: id,
      langId: langId,
      langCode: langCode,
      lemma: lemma,
      group: verbGroup,
      auxiliaries: auxList,
      isPronominal: isPronominal,
      reflexiveCase: reflexiveCase,
      isIrregular: isIrregular,
      isDefective: isDefective,
      generalNote: noteMap,
      forms: formsList,
      source: source,
      isPublished: isPublished,
    );
  }
}

extension DeclensionEntryMapper on DeclensionEntry {
  DeclensionRecord toDomain(String langCode) {
    final noteMap = Map<String, String>.from(jsonDecode(generalNoteJson) as Map);
    final formsList = (jsonDecode(formsJson) as List)
        .map((e) => DeclensionForm.fromJson(Map<String, dynamic>.from(e as Map)))
        .toList();

    return DeclensionRecord(
      id: id,
      langId: langId,
      langCode: langCode,
      lemma: lemma,
      pos: DeclensionPos.tryParse(pos) ?? DeclensionPos.noun,
      gender: gender,
      declensionClass: declensionClass,
      isIrregular: isIrregular,
      isInvariable: isInvariable,
      generalNote: noteMap,
      forms: formsList,
      source: source,
      isPublished: isPublished,
    );
  }
}

extension GrammarLessonEntryMapper on GrammarLessonEntry {
  GrammarLessonRecord toDomain(String langCode) {
    return GrammarLessonRecord(
      id: id,
      langId: langId,
      langCode: langCode,
      slug: slug,
      level: level,
      order: orderIndex,
      title: Map<String, String>.from(jsonDecode(titleJson) as Map),
      prerequisiteIds: List<int>.from(jsonDecode(prerequisiteIdsJson) as List),
      linkedVerbIds: List<int>.from(jsonDecode(linkedVerbIdsJson) as List),
      targetTenses: (jsonDecode(targetTensesJson) as List)
          .map((e) => TargetTense.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      linkedDeclensionIds: List<int>.from(jsonDecode(linkedDeclensionIdsJson) as List),
      targetCases: List<String>.from(jsonDecode(targetCasesJson) as List),
      blocks: (jsonDecode(blocksJson) as List)
          .map((e) => LessonBlock.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      exercises: (jsonDecode(exercisesJson) as List)
          .map((e) => LessonExercise.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      isPublished: isPublished,
    );
  }
}

extension LessonProgressEntryMapper on LessonProgressEntry {
  LessonProgressRecord toDomain() {
    final rawMap = Map<String, dynamic>.from(jsonDecode(exerciseResultsJson) as Map);
    final results = rawMap.map(
      (k, v) => MapEntry(
        k,
        ExerciseResult.fromJson(Map<String, dynamic>.from(v as Map)),
      ),
    );
    return LessonProgressRecord(
      id: id,
      userKey: userKey,
      lessonId: lessonId,
      exerciseResults: results,
      score: score,
      lastSeenAt: lastSeenAt,
      nextDueAt: nextDueAt,
    );
  }
}
