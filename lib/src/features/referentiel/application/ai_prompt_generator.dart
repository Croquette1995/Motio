import 'dart:convert';
import '../domain/conjugation.dart';
import '../domain/declension.dart';
import '../domain/grammar_lesson.dart';
import '../domain/grammar_profile.dart';

class AiPromptGenerator {
  AiPromptGenerator._();

  static String generateSystemPrompt({
    required LanguageRecord language,
    List<ConjugationRecord> sampleConjugations = const [],
    List<DeclensionRecord> sampleDeclensions = const [],
    List<GrammarLessonRecord> sampleLessons = const [],
  }) {
    final profileJson = const JsonEncoder.withIndent('  ').convert(language.grammarProfile.toJson());
    final examples = <String, dynamic>{
      'schema_version': '1.3',
      'lang': language.code,
      'conjugations': sampleConjugations.take(1).map((c) => c.toBundleJson()).toList(),
      if (language.grammarProfile.hasDeclensions)
        'declensions': sampleDeclensions.take(1).map((d) => d.toBundleJson()).toList(),
      'lessons': sampleLessons.take(1).map((l) => {
            'slug': l.slug,
            'level': l.level,
            'order': l.order,
            'title': l.title,
            'target_tenses': l.targetTenses.map((t) => t.toJson()).toList(),
            'target_cases': l.targetCases,
            'blocks': l.blocks.map((b) => b.toJson()).toList(),
            'exercises': l.exercises.map((e) => e.toJson()).toList(),
          }).toList(),
    };
    final examplesJson = const JsonEncoder.withIndent('  ').convert(examples);

    return '''
Tu es un expert en linguistique et en ingénierie pédagogique pour la langue "${language.displayName()}" (code: "${language.code}").
Génère uniquement un JSON valide respectant strictement l'enveloppe bundle v1.3 (`schema_version: "1.3"`, `lang: "${language.code}"`).

=== GRAMMAR_PROFILE (${language.code}) ===
$profileJson

=== RÈGLES STRICTES v1.3 ===
1. Toutes les clés JSON sont en ASCII strict (`snake_case`). Chaînes normalisées NFC (roumain : virgules souscrites `ș`/`ț`, pas de cédilles).
2. Conjugaisons (`conjugations`) :
   - Formes fléchies pré-calculées complètes, SANS pronom sujet (`"ai pris"`, `"mă spăl"`, `"me suis lavé"`).
   - Temps composés écrits en toutes lettres ; si le verbe a >1 auxiliaire, renseigner `auxiliary` sur chaque forme composée.
   - Verbes pronominaux : renseigner `pronoun` ET `bare_form` ensemble (ou aucun des deux).
   - Verbes défectifs : `is_defective: true`, n'inclure que les formes attestées.
3. Déclinaisons (`declensions`) :
   - Autorisé uniquement si `has_declensions == true`. `pos` dans `["NOUN", "ADJ", "DET"]`.
   - Séparation stricte : `declension_class` est réservé aux `NOUN` (toujours `null` sur `ADJ`/`DET`) ; `definiteness` (`DEF` / `INDEF` / `ZERO`) est une dimension de forme (ex. régime faible/mixte/fort de l'adjectif allemand).
   - Roumain `NOUN` (`INDEF`) : toujours inclure le déterminant indéfini dans `article` + `form` (`un om`, `unui om`, `niște oameni`, `unor oameni`). Sur `DEF`, omettre `article` et `bare_form` (`omul`, `oamenii`).
   - Si `article` et `bare_form` sont utilisés, les deux doivent être présents ensemble.
4. Leçons (`grammar_lessons`) :
   - Chaque bloc (`rule`, `exception`, `tip`, `table`) et exercice (`cloze`, `qcm`, `transformation`) porte un `id` ASCII unique.
   - `linked_declensions` utilise impérativement la clé composite `"<lemma>#<POS>"` (ex. `"Tisch#NOUN"`).
   - Dans un `qcm`, `answer` ne doit jamais figurer dans `distractors`.
5. Prudence : marquer `"needs_review": true` sur toute forme incertaine (bloque la publication jusqu'à validation humaine).

=== EXEMPLES FEW-SHOT (${language.code}) ===
$examplesJson
''';
  }
}
