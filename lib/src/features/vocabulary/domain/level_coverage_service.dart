import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../settings/domain/cefr_level.dart';

/// Couverture d'un niveau CECRL : nombre de mots en base pour ce niveau et
/// cette langue apprise, rapporté au quota non cumulé du niveau
/// (`CefrLevel.levelWordQuota`).
class LevelCoverage {
  final CefrLevel level;

  /// Code de la langue apprise ('en', 'fr', ...).
  final String languageCode;
  final int wordCount;
  final int quota;
  final DateTime updatedAt;

  const LevelCoverage({
    required this.level,
    required this.languageCode,
    required this.wordCount,
    required this.quota,
    required this.updatedAt,
  });

  /// Taux de couverture du quota (0.0 à 1.0).
  double get coverageRate => LevelCoverageService.coverageRate(wordCount, quota);

  /// Nombre de mots restants à couvrir pour atteindre le quota.
  int get remainingWords => LevelCoverageService.remainingQuota(wordCount, quota);

  /// Vrai lorsque le quota du niveau est atteint ou dépassé.
  bool get isQuotaReached => remainingWords <= 0;
}

/// Service de couverture du barème CECRL.
///
/// Calcule les mots par niveau et par langue apprise à partir des données
/// persistées en base Drift (`WordsTable.level`, `WordsTable.language`,
/// `WordsTable.frequencyScore`), et persiste un snapshot de couverture par
/// langue apprise dans `LevelCoverageTable`.
class LevelCoverageService {
  final AppDatabase db;

  const LevelCoverageService(this.db);

  /// Pourcentage de remplissage du quota (0.0 à 1.0), calcul pur testable.
  static double coverageRate(int wordCount, int quota) {
    if (quota <= 0) return 0.0;
    return (wordCount / quota).clamp(0.0, 1.0);
  }

  /// Quota restant à couvrir (jamais négatif), calcul pur testable.
  static int remainingQuota(int wordCount, int quota) {
    final remaining = quota - wordCount;
    return remaining > 0 ? remaining : 0;
  }

  /// Compte les mots persistés pour un niveau et une langue donnés.
  Future<int> countWords(CefrLevel level, {String language = 'en'}) async {
    final countExp = db.wordsTable.id.count();
    final query = db.selectOnly(db.wordsTable)
      ..addColumns([countExp])
      ..where(
        db.wordsTable.level.upper().equals(level.code) &
            db.wordsTable.language.equals(language),
      );
    final row = await query.getSingle();
    return row.read(countExp) ?? 0;
  }

  /// Couverture courante d'un niveau pour une langue apprise : le nombre de
  /// mots est recalculé depuis les données persistées, puis le snapshot est
  /// persisté dans `LevelCoverageTable`.
  Future<LevelCoverage> refreshCoverage(CefrLevel level, {String language = 'en'}) async {
    final wordCount = await countWords(level, language: language);
    final coverage = LevelCoverage(
      level: level,
      languageCode: language,
      wordCount: wordCount,
      quota: level.levelWordQuota,
      updatedAt: DateTime.now(),
    );

    await db.into(db.levelCoverageTable).insertOnConflictUpdate(
          LevelCoverageTableCompanion.insert(
            language: language,
            level: level.code,
            wordCount: wordCount,
            quota: level.levelWordQuota,
            updatedAt: Value(coverage.updatedAt),
          ),
        );

    return coverage;
  }

  /// Dernier snapshot persisté pour un niveau et une langue, s'il existe.
  Future<LevelCoverage?> getPersistedCoverage(CefrLevel level, {String language = 'en'}) async {
    final query = db.select(db.levelCoverageTable)
      ..where(
        (tbl) => tbl.level.upper().equals(level.code) & tbl.language.equals(language),
      );
    final entry = await query.getSingleOrNull();
    if (entry == null) return null;
    return LevelCoverage(
      level: level,
      languageCode: entry.language,
      wordCount: entry.wordCount,
      quota: entry.quota,
      updatedAt: entry.updatedAt,
    );
  }

  /// Couvertures de tous les niveaux pour une langue apprise, système de
  /// vérité recalculé puis persisté.
  Future<Map<CefrLevel, LevelCoverage>> refreshAllLevels({String language = 'en'}) async {
    final coverages = <CefrLevel, LevelCoverage>{};
    for (final level in CefrLevel.values) {
      coverages[level] = await refreshCoverage(level, language: language);
    }
    return coverages;
  }
}
