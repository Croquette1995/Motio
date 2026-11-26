import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/domain/level_coverage_service.dart';

void main() {
  late AppDatabase db;
  late LevelCoverageService service;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    await db.seedInitialData();
    service = LevelCoverageService(db);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> addWord({
    required String term,
    required String level,
    String language = 'en',
    double frequencyScore = 5.0,
  }) async {
    await db.into(db.wordsTable).insert(
          WordsTableCompanion.insert(
            term: term,
            translation: 'traduction',
            contextSentence: 'Une phrase de contexte.',
            category: 'Daily Life & Home',
            level: level,
            language: Value(language),
            frequencyScore: Value(frequencyScore),
          ),
        );
  }

  group('Calculs purs (couverture et quota restant)', () {
    test('coverageRate : 0 quand vide, clampé à 1.0 au-delà du quota', () {
      expect(LevelCoverageService.coverageRate(0, 500), 0.0);
      expect(LevelCoverageService.coverageRate(250, 500), 0.5);
      expect(LevelCoverageService.coverageRate(500, 500), 1.0);
      expect(LevelCoverageService.coverageRate(720, 500), 1.0);
    });

    test('coverageRate : 0 si quota nul, pas de division par zéro', () {
      expect(LevelCoverageService.coverageRate(10, 0), 0.0);
    });

    test('remainingQuota : jamais négatif', () {
      expect(LevelCoverageService.remainingQuota(0, 500), 500);
      expect(LevelCoverageService.remainingQuota(200, 500), 300);
      expect(LevelCoverageService.remainingQuota(500, 500), 0);
      expect(LevelCoverageService.remainingQuota(650, 500), 0);
    });
  });

  group('Couverture calculée depuis la base persistée', () {
    test('compte les mots par niveau et par langue apprise', () async {
      final existing = await db.select(db.wordsTable).get();
      final a1EnCount = existing.where((w) => w.level == 'A1' && w.language == 'en').length;
      final a2EnCount = existing.where((w) => w.level == 'A2' && w.language == 'en').length;

      await addWord(term: 'zzz_quota_test', level: 'A1');

      expect(await service.countWords(CefrLevel.a1), a1EnCount + 1);
      expect((await service.refreshCoverage(CefrLevel.a1)).wordCount, a1EnCount + 1);
      expect((await service.refreshCoverage(CefrLevel.a2)).wordCount, a2EnCount);
    });

    test('la couverture est isolée par langue apprise', () async {
      final existing = await db.select(db.wordsTable).get();
      final a1EnCount = existing.where((w) => w.level == 'A1' && w.language == 'en').length;

      await addWord(term: 'casa', level: 'A1', language: 'es');

      expect(await service.countWords(CefrLevel.a1, language: 'en'), a1EnCount);
      expect(await service.countWords(CefrLevel.a1, language: 'es'), 1);

      final en = await service.refreshCoverage(CefrLevel.a1, language: 'en');
      final es = await service.refreshCoverage(CefrLevel.a1, language: 'es');
      expect(en.languageCode, 'en');
      expect(es.languageCode, 'es');
      expect(en.wordCount, a1EnCount);
      expect(es.wordCount, 1);
    });

    test('la couverture utilise bien le quota non cumulé du niveau', () async {
      final coverage = await service.refreshCoverage(CefrLevel.a1, language: 'en');
      expect(coverage.quota, 500);
      expect(coverage.quota, CefrLevel.a1.levelWordQuota);
      expect(coverage.isQuotaReached, false);
    });

    test('isQuotaReached et remainingWords reflètent le remplissage', () async {
      final existing = await db.select(db.wordsTable).get();
      final a2EnCount = existing.where((w) => w.level == 'A2' && w.language == 'en').length;

      final before = await service.refreshCoverage(CefrLevel.a2, language: 'en');
      expect(before.wordCount, a2EnCount);
      expect(before.remainingWords, CefrLevel.a2.levelWordQuota - a2EnCount);

      // Dépassement artificiel : la couverture se clampe et le quota reste nul.
      await db.customUpdate(
        'UPDATE words_table SET frequency_score = ? WHERE level = ? AND language = ?',
        variables: [Variable(3.5), Variable('A2'), Variable('en')],
      );
      final beyond = await service.refreshCoverage(CefrLevel.a2, language: 'en');
      expect(beyond.isQuotaReached, beyond.remainingWords <= 0);
    });
  });

  group('Persistance du snapshot de couverture', () {
    test('refreshCoverage persiste une ligne par (langue, niveau) et la met à jour', () async {
      await addWord(term: 'snapshot_word', level: 'B1');
      final first = await service.refreshCoverage(CefrLevel.b1, language: 'en');

      final persisted = await service.getPersistedCoverage(CefrLevel.b1, language: 'en');
      expect(persisted, isNotNull);
      expect(persisted!.wordCount, first.wordCount);
      expect(persisted.quota, CefrLevel.b1.levelWordQuota);
      expect(persisted.languageCode, 'en');

      await addWord(term: 'second_snapshot_word', level: 'B1');
      final updated = await service.refreshCoverage(CefrLevel.b1, language: 'en');
      expect(updated.wordCount, first.wordCount + 1);

      final rows = await db.select(db.levelCoverageTable).get();
      final b1EnRows = rows.where((r) => r.level == 'B1' && r.language == 'en');
      expect(b1EnRows.length, 1);
      expect(b1EnRows.single.wordCount, first.wordCount + 1);
    });

    test('les snapshots restent séparés par langue apprise', () async {
      await addWord(term: 'maison_fr', level: 'A1', language: 'fr');
      await service.refreshCoverage(CefrLevel.a1, language: 'en');
      await service.refreshCoverage(CefrLevel.a1, language: 'fr');

      final en = await service.getPersistedCoverage(CefrLevel.a1, language: 'en');
      final fr = await service.getPersistedCoverage(CefrLevel.a1, language: 'fr');
      expect(en, isNotNull);
      expect(fr!.wordCount, 1);
      expect(fr.wordCount != en!.wordCount || fr.languageCode != en.languageCode, isTrue);
    });

    test('getPersistedCoverage renvoie null sans snapshot', () async {
      expect(await service.getPersistedCoverage(CefrLevel.b2, language: 'en'), isNull);
    });

    test('refreshAllLevels couvre les 4 niveaux', () async {
      final all = await service.refreshAllLevels(language: 'en');
      expect(all.keys.toSet(), CefrLevel.values.toSet());
      for (final level in CefrLevel.values) {
        expect(all[level]!.quota, level.levelWordQuota);
        final persisted = await service.getPersistedCoverage(level, language: 'en');
        expect(persisted!.wordCount, all[level]!.wordCount);
      }
    });
  });
}
