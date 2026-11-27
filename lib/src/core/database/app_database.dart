import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/words_table.dart';
import 'tables/word_progress_table.dart';
import 'tables/unimorph_forms_table.dart';
import 'tables/grammar_rules_table.dart';
import 'tables/languages_table.dart';
import 'tables/conjugations_table.dart';
import 'tables/declensions_table.dart';
import 'tables/grammar_lessons_table.dart';
import 'tables/lesson_progress_table.dart';
import 'tables/level_coverage_table.dart';
import '../../features/vocabulary/data/initial_words_seed.dart';
import '../../features/vocabulary/domain/lemmatizer.dart';
import '../../features/referentiel/data/referentiel_seed_data.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  WordsTable,
  WordProgressTable,
  UnimorphFormsTable,
  GrammarRulesTable,
  LanguagesTable,
  ConjugationsTable,
  DeclensionsTable,
  GrammarLessonsTable,
  LessonProgressTable,
  LevelCoverageTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 4;

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'lexiflow',
      web: DriftWebOptions(
        sqlite3Wasm: Uri.parse('sqlite3.wasm'),
        driftWorker: Uri.parse('drift_worker.js'),
      ),
    );
  }

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await seedInitialData();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.addColumn(wordsTable, wordsTable.language);
            await m.addColumn(wordsTable, wordsTable.targetLanguage);
            await m.addColumn(wordsTable, wordsTable.pos);
            await m.addColumn(wordsTable, wordsTable.frequencyScore);
            await m.addColumn(wordsTable, wordsTable.lemma);
            await m.createTable(unimorphFormsTable);
            await m.createTable(grammarRulesTable);
            await seedA1A2Data();
          }
          if (from < 3) {
            await m.createTable(languagesTable);
            await m.createTable(conjugationsTable);
            await m.createTable(declensionsTable);
            await m.createTable(grammarLessonsTable);
            await m.createTable(lessonProgressTable);
            await seedReferentielV13Data();
          }
          if (from < 4) {
            await m.createTable(levelCoverageTable);
          }
        },
      );

  Future<void> seedA1A2Data() async {
    final existingTerms = (await select(wordsTable).get()).map((w) => w.term.toLowerCase()).toSet();
    final missingSeeds = initialWordsSeed.where((s) => !existingTerms.contains(s.term.toLowerCase())).toList();
    if (missingSeeds.isEmpty) return;

    await batch((batch) {
      for (final seed in missingSeeds) {
        batch.insert(
          wordsTable,
          WordsTableCompanion.insert(
            term: seed.term,
            translation: seed.translation,
            contextSentence: seed.contextSentence,
            category: seed.category,
            level: seed.level,
            language: Value(seed.language),
            targetLanguage: const Value('fr'),
            pos: Value(seed.pos),
            frequencyScore: Value(seed.frequencyScore),
          ),
        );
      }
    });

    final words = await select(wordsTable).get();
    final existingProgressWordIds = (await select(wordProgressTable).get()).map((p) => p.wordId).toSet();

    await batch((batch) {
      for (final word in words) {
        if (!existingProgressWordIds.contains(word.id)) {
          batch.insert(
            wordProgressTable,
            WordProgressTableCompanion.insert(
              wordId: word.id,
              status: 'new',
              step: const Value(0),
              easeFactor: const Value(2.5),
              intervalDays: const Value(0),
              consecutiveSuccesses: const Value(0),
            ),
          );
        }
      }
    });
  }

  Future<void> seedInitialData() async {
    final existingWords = await select(wordsTable).get();
    if (existingWords.isEmpty) {
      await batch((batch) {
        for (final seed in initialWordsSeed) {
          batch.insert(
            wordsTable,
            WordsTableCompanion.insert(
              term: seed.term,
              translation: seed.translation,
              contextSentence: seed.contextSentence,
              category: seed.category,
              level: seed.level,
              language: Value(seed.language),
              targetLanguage: const Value('fr'),
              pos: Value(seed.pos),
              frequencyScore: Value(seed.frequencyScore),
            ),
          );
        }
      });

      final words = await select(wordsTable).get();
      await batch((batch) {
        for (final word in words) {
          batch.insert(
            wordProgressTable,
            WordProgressTableCompanion.insert(
              wordId: word.id,
              status: 'new',
              step: const Value(0),
              easeFactor: const Value(2.5),
              intervalDays: const Value(0),
              consecutiveSuccesses: const Value(0),
            ),
          );
        }
      });
    }

    await seedReferentielV13Data();
  }

  /// Pré-charge de manière idempotente les langues (`fr`, `ro`, `de`, `en`)
  /// et le jeu de données d'acceptation v1.3 (conjugaisons, déclinaisons, leçons).
  Future<void> seedReferentielV13Data() async {
    final langIdByCode = <String, int>{};
    final existingLangs = await select(languagesTable).get();
    for (final l in existingLangs) {
      langIdByCode[l.code] = l.id;
    }

    for (final spec in seedLanguagesV13) {
      if (!langIdByCode.containsKey(spec.code)) {
        final id = await into(languagesTable).insert(
          LanguagesTableCompanion.insert(
            code: spec.code,
            nameL10nJson: spec.nameL10nJson,
            isNonLatin: Value(spec.isNonLatin),
            grammarProfileJson: spec.grammarProfileJson,
          ),
        );
        langIdByCode[spec.code] = id;
      }
    }

    final existingConj = await select(conjugationsTable).get();
    final conjIdByKey = <String, int>{};
    for (final c in existingConj) {
      final code = langIdByCode.entries.firstWhere((e) => e.value == c.langId).key;
      conjIdByKey['$code:${c.lemma}'] = c.id;
    }

    for (final raw in seedConjugationsV13) {
      final code = raw['lang'] as String;
      final langId = langIdByCode[code]!;
      final lemma = raw['lemma'] as String;
      final key = '$code:$lemma';
      if (!conjIdByKey.containsKey(key)) {
        final id = await into(conjugationsTable).insert(
          ConjugationsTableCompanion.insert(
            langId: langId,
            lemma: lemma,
            verbGroup: Value(raw['group'] as String?),
            auxiliariesJson: Value(jsonEncode(raw['auxiliaries'] ?? const [])),
            isPronominal: Value((raw['is_pronominal'] as bool?) ?? false),
            reflexiveCase: Value(raw['reflexive_case'] as String?),
            isIrregular: Value((raw['is_irregular'] as bool?) ?? false),
            isDefective: Value((raw['is_defective'] as bool?) ?? false),
            generalNoteJson: Value(jsonEncode(raw['general_note'] ?? const {})),
            formsJson: Value(jsonEncode(raw['forms'] ?? const [])),
            source: Value((raw['source'] as String?) ?? 'manual'),
            isPublished: Value((raw['is_published'] as bool?) ?? true),
          ),
        );
        conjIdByKey[key] = id;
      }
    }

    final existingDecl = await select(declensionsTable).get();
    final declIdByKey = <String, int>{};
    for (final d in existingDecl) {
      final code = langIdByCode.entries.firstWhere((e) => e.value == d.langId).key;
      declIdByKey['$code:${d.lemma}#${d.pos}'] = d.id;
    }

    for (final raw in seedDeclensionsV13) {
      final code = raw['lang'] as String;
      final langId = langIdByCode[code]!;
      final lemma = raw['lemma'] as String;
      final pos = raw['pos'] as String;
      final key = '$code:$lemma#$pos';
      if (!declIdByKey.containsKey(key)) {
        final id = await into(declensionsTable).insert(
          DeclensionsTableCompanion.insert(
            langId: langId,
            lemma: lemma,
            pos: pos,
            gender: Value(raw['gender'] as String?),
            declensionClass: Value(raw['declension_class'] as String?),
            isIrregular: Value((raw['is_irregular'] as bool?) ?? false),
            isInvariable: Value((raw['is_invariable'] as bool?) ?? false),
            generalNoteJson: Value(jsonEncode(raw['general_note'] ?? const {})),
            formsJson: Value(jsonEncode(raw['forms'] ?? const [])),
            source: Value((raw['source'] as String?) ?? 'manual'),
            isPublished: Value((raw['is_published'] as bool?) ?? true),
          ),
        );
        declIdByKey[key] = id;
      }
    }

    final existingLessons = await select(grammarLessonsTable).get();
    final existingLessonKeys = <String>{};
    for (final l in existingLessons) {
      final code = langIdByCode.entries.firstWhere((e) => e.value == l.langId).key;
      existingLessonKeys.add('$code:${l.slug}');
    }

    for (final raw in seedLessonsV13) {
      final code = raw['lang'] as String;
      final langId = langIdByCode[code]!;
      final slug = raw['slug'] as String;
      if (existingLessonKeys.contains('$code:$slug')) continue;

      final linkedVerbIds = (raw['linked_verbs'] as List? ?? const [])
          .map((lemma) => conjIdByKey['$code:$lemma'])
          .whereType<int>()
          .toList();
      final linkedDeclIds = (raw['linked_declensions'] as List? ?? const [])
          .map((refKey) => declIdByKey['$code:$refKey'])
          .whereType<int>()
          .toList();

      await into(grammarLessonsTable).insert(
        GrammarLessonsTableCompanion.insert(
          langId: langId,
          slug: slug,
          level: raw['level'] as String,
          orderIndex: Value((raw['order'] as int?) ?? 1),
          titleJson: Value(jsonEncode(raw['title'] ?? const {})),
          prerequisiteIdsJson: const Value('[]'),
          linkedVerbIdsJson: Value(jsonEncode(linkedVerbIds)),
          targetTensesJson: Value(jsonEncode(raw['target_tenses'] ?? const [])),
          linkedDeclensionIdsJson: Value(jsonEncode(linkedDeclIds)),
          targetCasesJson: Value(jsonEncode(raw['target_cases'] ?? const [])),
          blocksJson: Value(jsonEncode(raw['blocks'] ?? const [])),
          exercisesJson: Value(jsonEncode(raw['exercises'] ?? const [])),
          isPublished: Value((raw['is_published'] as bool?) ?? true),
        ),
      );
    }
  }

  /// Déduplication : vérifie si un mot existe déjà dans la base locale
  /// (insensible à la casse), sur la forme de surface PUIS son lemme (Issue 32).
  Future<bool> wordExists(String term, {String language = 'en'}) async {
    final clean = term.trim().toLowerCase();
    final lemma = lemmatize(clean, language: language);
    final query = select(wordsTable)
      ..where((tbl) {
        var condition =
            tbl.term.lower().equals(clean) & tbl.language.equals(language);
        if (lemma != clean) {
          condition = condition |
              (tbl.term.lower().equals(lemma) & tbl.language.equals(language));
        }
        return condition;
      });
    final result = await query.getSingleOrNull();
    return result != null;
  }
}
