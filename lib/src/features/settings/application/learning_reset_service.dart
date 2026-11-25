import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/database_providers.dart';
import '../../vocabulary/data/initial_words_seed.dart';
import 'level_unlock_controller.dart';

/// Options choisies dans le dialogue « Recommencer » (étape 1).
class LearningResetOptions {
  final bool resetProgress;
  final bool deleteTatoebaWords;
  final bool relaunchOnboarding;

  const LearningResetOptions({
    this.resetProgress = true,
    this.deleteTatoebaWords = false,
    this.relaunchOnboarding = true,
  });

  bool get hasAnyAction => resetProgress || deleteTatoebaWords || relaunchOnboarding;
}

/// Résumé de l'opération, affiché à l'utilisateur après l'étape finale.
class LearningResetSummary {
  final int wordProgressRowsDeleted;
  final int lessonProgressRowsDeleted;
  final int wordsDeleted;

  const LearningResetSummary({
    this.wordProgressRowsDeleted = 0,
    this.lessonProgressRowsDeleted = 0,
    this.wordsDeleted = 0,
  });

  String message() {
    final parts = <String>[
      if (wordProgressRowsDeleted > 0)
        '$wordProgressRowsDeleted états de révision réinitialisés',
      if (lessonProgressRowsDeleted > 0)
        '$lessonProgressRowsDeleted leçons réinitialisées',
      if (wordsDeleted > 0) '$wordsDeleted mots ajoutés supprimés',
    ];
    if (parts.isEmpty) return 'Recommencement effectué.';
    return 'Recommencement effectué : ${parts.join(' · ')}.';
  }
}

/// Réinitialisation des données utilisateur.
///
/// Le référentiel embarqué (vocabulaire intégré, grammaire, conjugaisons,
/// déclinaisons, UniMorph) n'est jamais modifié : seules les données issues de
/// l'apprentissage (progression SRS, leçons) et les mots ajoutés par
/// l'utilisateur depuis l'explorateur Tatoeba sont supprimés.
class LearningResetService {
  final AppDatabase db;

  const LearningResetService(this.db);

  static final Set<String> _embeddedSeedTerms = {
    for (final seed in initialWordsSeed) seed.term.toLowerCase(),
  };

  Future<LearningResetSummary> reset({required LearningResetOptions options}) {
    return db.transaction(() async {
      var progressRows = 0;
      var lessonRows = 0;
      var wordsDeleted = 0;

      if (options.resetProgress) {
        lessonRows = await db.delete(db.lessonProgressTable).go();
        progressRows = await db.delete(db.wordProgressTable).go();
      }

      if (options.deleteTatoebaWords) {
        wordsDeleted = await _deleteUserAddedWords();
      }

      return LearningResetSummary(
        wordProgressRowsDeleted: progressRows,
        lessonProgressRowsDeleted: lessonRows,
        wordsDeleted: wordsDeleted,
      );
    });
  }

  Future<int> _deleteUserAddedWords() async {
    final entries = await db.select(db.wordsTable).get();
    final userTerms = entries
        .map((e) => e.term.toLowerCase())
        .where((term) => !_embeddedSeedTerms.contains(term))
        .toSet();
    if (userTerms.isEmpty) return 0;

    return (db.delete(db.wordsTable)
          ..where((tbl) => tbl.term.lower().isIn(userTerms)))
        .go();
  }

  /// Efface les préférences dérivées de l'apprentissage (déblocages).
  Future<void> clearUnlocks() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(LevelUnlockService.prefsKey);
  }
}

final learningResetServiceProvider = Provider<LearningResetService>((ref) {
  return LearningResetService(ref.watch(appDatabaseProvider));
});
