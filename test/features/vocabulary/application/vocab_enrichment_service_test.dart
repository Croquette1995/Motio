import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/application/vocab_enrichment_service.dart';
import 'package:lexiflow/src/features/vocabulary/data/drift_word_repository.dart';
import 'package:lexiflow/src/features/vocabulary/data/tatoeba_service.dart';
import 'package:lexiflow/src/features/vocabulary/domain/tatoeba_sentence.dart';

class _PagedTatoebaService extends TatoebaService {
  _PagedTatoebaService(this.pages);

  final List<List<TatoebaSentence>> pages;
  int _page = 0;
  int fetchCalls = 0;

  @override
  Future<List<TatoebaSentence>> searchSentences({
    String from = 'eng',
    String to = 'fra',
    String query = '',
    bool random = true,
    int pageSize = 5,
    int wordCountMin = 3,
    int wordCountMax = 12,
  }) async {
    fetchCalls++;
    if (_page >= pages.length) return [];
    final page = pages[_page];
    _page++;
    return page;
  }
}

void main() {
  late AppDatabase testDb;
  late DriftWordRepository repo;

  setUp(() async {
    testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();
    repo = DriftWordRepository(testDb);
  });

  tearDown(() async {
    await testDb.close();
  });

  Future<String> quickTranslation(String term) async => 'trad-$term';

  // 'dog', 'cat', 'milk' : Zipf A1 (5.5+) hors seeds.
  // 'station' : A2 (4.8) et 'feedback' : B1 (4.3), hors niveau actif.
  // Les phrases font au moins 4 mots : seuil du filtre qualité A1 (Issue 28).
  TatoebaSentence sentenceOf(String textEn) => TatoebaSentence(
        id: textEn.hashCode,
        textEn: textEn,
        textFr: 'traduction $textEn',
      );

  group('VocabEnrichmentService.levelQuota', () {
    test('follows the incremental CECRL scale', () {
      expect(VocabEnrichmentService.levelQuota(CefrLevel.a1), 500);
      expect(VocabEnrichmentService.levelQuota(CefrLevel.a2), 700);
      expect(VocabEnrichmentService.levelQuota(CefrLevel.b1), 1000);
      expect(VocabEnrichmentService.levelQuota(CefrLevel.b2), 1300);
    });
  });

  group('VocabEnrichmentService.runToQuota', () {
    test('stops immediately (idempotent) when the quota is already reached',
        () async {
      final service = VocabEnrichmentService(
        wordRepository: repo,
        translationResolver: quickTranslation,
      );

      final result = await service.runToQuota(
        level: CefrLevel.a1,
        quotaOverride: 20,
      );

      expect(result.status, EnrichmentRunStatus.quotaAlreadyReached);
      expect(result.addedWords, 0);
      expect(result.targetWords, 20);
    });

    test('fills the quota with active-level words only, without duplicates',
        () async {
      final tatoeba = _PagedTatoebaService([
        [sentenceOf('the dog is happy')],
        [sentenceOf('the cat drinks milk')],
        [sentenceOf('station feedback water')],
      ]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      final progressUpdates = <int>[];
      final result = await service.runToQuota(
        level: CefrLevel.a1,
        onProgress: (p) => progressUpdates.add(p.addedWords),
        quotaOverride: 23, // 20 seeds A1 + 3 mots attendus
      );

      final words = await repo.getWordsByLevel('A1');
      final addedTerms = words
          .map((w) => w.term)
          .where((t) => ['dog', 'cat', 'milk'].contains(t))
          .toList();

      expect(result.status, EnrichmentRunStatus.completed);
      expect(result.addedWords, 3);
      expect(addedTerms.toSet(), {'dog', 'cat', 'milk'},
          reason: 'seuls les mots du niveau actif sont ajoutés, sans doublon');
      expect(result.sentencesAnalyzed, 2,
          reason: 'le pipeline s\'arrête dès que le quota est atteint');
      expect(progressUpdates, isNotEmpty);
      expect(progressUpdates.first, 0);
      expect(progressUpdates.last, 3);
    });

    test('ignores words outside the active level', () async {
      final tatoeba = _PagedTatoebaService([
        [sentenceOf('the station feedback was clear')],
      ]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      final result = await service.runToQuota(
        level: CefrLevel.a2,
        quotaOverride: 11, // 10 seeds A2 : aucun nouveau mot ne doit sortir
      );

      expect(result.addedWords, 0,
          reason: 'station (seed) ignoré, feedback (B1) hors niveau');
      final words = await repo.getWordsByLevel('A2');
      expect(words, hasLength(10));
    });

    test('stops cleanly after consecutive empty fetches without network',
        () async {
      final tatoeba = _PagedTatoebaService([]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      final result = await service.runToQuota(
        level: CefrLevel.a1,
        isCancelled: () => false,
        maxConsecutiveEmptyFetches: 2,
        quotaOverride: 500,
      );

      expect(result.status, EnrichmentRunStatus.networkError);
      expect(result.errorMessage, isNotNull);
      expect(tatoeba.fetchCalls, 2);
      expect(result.sentencesAnalyzed, 0);
    });

    test('reports cancellation and keeps incremental additions', () async {
      final tatoeba = _PagedTatoebaService([
        [sentenceOf('the dog runs very fast')],
        [sentenceOf('the cat sleeps now')],
      ]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      var cancelled = true;
      final result = await service.runToQuota(
        level: CefrLevel.a1,
        isCancelled: () => cancelled,
        maxBatches: 2,
        quotaOverride: 22, // 20 seeds + 2 ajoutés attendus
      );

      expect(result.status, EnrichmentRunStatus.cancelled);
      expect(result.addedWords, 0);

      cancelled = false;
      final secondRun = await service.runToQuota(
        level: CefrLevel.a1,
        maxBatches: 2,
        quotaOverride: 22, // 20 seeds + 2 expectés
      );

      expect(secondRun.status, EnrichmentRunStatus.completed);
      expect(secondRun.addedWords, 2);
      final added = await repo.getWordsByLevel('A1');
      expect(added.map((w) => w.term), containsAll(['dog', 'cat']));
    });

    test('resumes after interruption without duplicated words', () async {
      final tatoeba = _PagedTatoebaService([
        [sentenceOf('the dog plays outside')],
        [sentenceOf('the dog plays outside'), sentenceOf('the cat sleeps now')],
      ]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      final firstRun = await service.runToQuota(
        level: CefrLevel.a1,
        quotaOverride: 22,
        maxBatches: 1,
      );
      expect(firstRun.status, EnrichmentRunStatus.sourceExhausted);
      expect(firstRun.addedWords, 1);

      final secondRun = await service.runToQuota(
        level: CefrLevel.a1,
        quotaOverride: 22,
        maxBatches: 1,
      );
      expect(secondRun.status, EnrichmentRunStatus.completed);
      expect(secondRun.addedWords, 1);

      final words = await repo.getWordsByLevel('A1');
      expect(words.where((w) => w.term == 'dog'), hasLength(1));
      expect(words.where((w) => w.term == 'cat'), hasLength(1));
    });

    test('stores translation, sentence context and level code', () async {
      final tatoeba = _PagedTatoebaService([
        [sentenceOf('milk is good today')],
      ]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      await service.runToQuota(
        level: CefrLevel.a1,
        quotaOverride: 21,
        maxBatches: 1,
      );

      final milk =
          (await repo.getWordsByLevel('A1')).firstWhere((w) => w.term == 'milk');
      expect(milk.translation, 'trad-milk');
      expect(milk.contextSentence, 'milk is good today');
      expect(milk.level, 'A1');
      expect(milk.category, isNotEmpty, reason: 'catégorie sémantique déduite');
    });
  });

  group('VocabEnrichmentService sentence quality filter (Issue 28)', () {
    test('drops parasitic sentences before analyzing words', () async {
      final tatoeba = _PagedTatoebaService([
        [
          sentenceOf('visit https://spam.example.com today'),
          sentenceOf('the cat drinks warm milk'),
        ],
      ]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      final result = await service.runToQuota(
        level: CefrLevel.a1,
        quotaOverride: 21,
        maxBatches: 1,
      );

      expect(result.sentencesAnalyzed, 1,
          reason: 'la phrase parasite (URL) est rejetée avant analyse');
      final words = await repo.getWordsByLevel('A1');
      final terms = words.map((w) => w.term).toList();
      expect(terms.any((t) => t.contains('example') || t.contains('spam')), isFalse);
    });

    test('never processes the same sentence twice in a run', () async {
      final tatoeba = _PagedTatoebaService([
        [
          sentenceOf('the dog plays outside'),
          sentenceOf('The dog plays outside!'),
        ],
      ]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      final result = await service.runToQuota(
        level: CefrLevel.a1,
        quotaOverride: 22,
        maxBatches: 1,
      );

      expect(result.sentencesAnalyzed, 1, reason: 'anti-doublon de phrases');
      expect(result.addedWords, 1);
    });

    test('processes the most level-relevant sentence first', () async {
      final tatoeba = _PagedTatoebaService([
        [
          sentenceOf('station feedback things matter'),
          sentenceOf('the cat drinks warm milk'),
        ],
      ]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      final result = await service.runToQuota(
        level: CefrLevel.a1,
        quotaOverride: 21, // un seul mot manquant : le meilleur lot gagne
        maxBatches: 1,
      );

      final words = await repo.getWordsByLevel('A1');
      expect(words.map((w) => w.term), contains('cat'),
          reason: 'la phrase la plus riche en mots A1 est traitée en premier');
      expect(result.addedWords, 1);
    });
  });

  group('VocabEnrichmentService source exhaustion', () {
    test('reports sourceExhausted when batches are used up', () async {
      final tatoeba = _PagedTatoebaService([
        [sentenceOf('the moon shines very bright')],
        [sentenceOf('the big sun shines today')],
      ]);
      final service = VocabEnrichmentService(
        wordRepository: repo,
        tatoebaService: tatoeba,
        translationResolver: quickTranslation,
      );

      final result = await service.runToQuota(
        level: CefrLevel.a1,
        quotaOverride: 500,
        maxBatches: 2,
      );

      expect(result.status, EnrichmentRunStatus.sourceExhausted);
      expect(result.addedWords, lessThan(500));
      expect(result.sentencesAnalyzed, 2);
    });
  });
}
