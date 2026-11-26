import '../../settings/domain/cefr_level.dart';
import '../data/tatoeba_service.dart';
import '../data/wiktionary_service.dart';
import '../domain/i_word_repository.dart';
import '../domain/sentence_quality_filter.dart';
import '../domain/tatoeba_sentence.dart';

typedef TranslationResolver = Future<String> Function(String term);

class EnrichmentProgress {
  final int addedWords;
  final int targetWords;
  final int sentencesAnalyzed;

  const EnrichmentProgress({
    required this.addedWords,
    required this.targetWords,
    required this.sentencesAnalyzed,
  });
}

enum EnrichmentRunStatus {
  quotaAlreadyReached,
  completed,
  cancelled,
  networkError,
  sourceExhausted,
}

class EnrichmentRunResult {
  final EnrichmentRunStatus status;
  final int addedWords;
  final int targetWords;
  final int sentencesAnalyzed;
  final String? errorMessage;

  const EnrichmentRunResult({
    required this.status,
    required this.addedWords,
    required this.targetWords,
    required this.sentencesAnalyzed,
    this.errorMessage,
  });
}

class VocabEnrichmentService {
  final IWordRepository wordRepository;
  final TatoebaService tatoebaService;
  final WiktionaryService wiktionaryService;
  final SentenceQualityFilter qualityFilter;
  final TranslationResolver? _externalTranslationResolver;

  VocabEnrichmentService({
    required this.wordRepository,
    TatoebaService? tatoebaService,
    WiktionaryService? wiktionaryService,
    SentenceQualityFilter? qualityFilter,
    TranslationResolver? translationResolver,
  })  : tatoebaService = tatoebaService ?? TatoebaService(),
        wiktionaryService = wiktionaryService ?? WiktionaryService(),
        qualityFilter = qualityFilter ?? const SentenceQualityFilter(),
        _externalTranslationResolver = translationResolver;

  /// Quota de mots propre au niveau (barème CECRL incrémental) :
  /// A1 = 500, A2 = +700, B1 = +1000, B2 = +1300 (deltas des cibles cumulées).
  static int levelQuota(CefrLevel level) {
    if (level.index == 0) return level.targetWordCount;
    return level.targetWordCount - CefrLevel.values[level.index - 1].targetWordCount;
  }

  Future<String> resolveTranslation(String term) async {
    final external = _externalTranslationResolver;
    if (external != null) return external(term);

    try {
      final details = await wiktionaryService.fetchWordDetails(term);
      if (details.translations.isNotEmpty) {
        return details.translations.first.term;
      }
      if (details.definitions.isNotEmpty) {
        return details.definitions.first.text;
      }
    } catch (_) {
      // La traduction sera complétée manuellement plus tard.
    }
    return 'Traduction à préciser';
  }

  /// Pipeline automatique d'enrichissement : récupération de phrases Tatoeba ->
  /// extraction des mots -> déduction du niveau (Zipf) -> catégorisation ->
  /// ajout sans doublon -> progression remontée en continu, jusqu'au quota.
  ///
  /// Idempotent : les mots déjà en base (seeds, runs précédents, run en cours)
  /// ne sont jamais re-traités. Résilient : les ajouts sont incrémentaux et
  /// l'appelant peut interrompre à tout moment via [isCancelled].
  Future<EnrichmentRunResult> runToQuota({
    required CefrLevel level,
    void Function(EnrichmentProgress progress)? onProgress,
    bool Function()? isCancelled,
    int batchSize = 20,
    int maxConsecutiveEmptyFetches = 3,
    int maxBatches = 40,
    int? quotaOverride,
  }) async {
    final quota = quotaOverride ?? levelQuota(level);
    final existing = await wordRepository.getWordsByLevel(level.code);
    final remaining = quota - existing.length;

    void report(int addedWords, int sentencesAnalyzed) {
      onProgress?.call(EnrichmentProgress(
        addedWords: addedWords,
        targetWords: quota,
        sentencesAnalyzed: sentencesAnalyzed,
      ));
    }

    if (remaining <= 0) {
      return EnrichmentRunResult(
        status: EnrichmentRunStatus.quotaAlreadyReached,
        addedWords: 0,
        targetWords: quota,
        sentencesAnalyzed: 0,
      );
    }

    var added = 0;
    var sentencesAnalyzed = 0;
    var emptyFetches = 0;
    var batches = 0;
    final addedTerms = <String>{};

    report(added, sentencesAnalyzed);

    while (added < remaining) {
      if (isCancelled?.call() ?? false) {
        return EnrichmentRunResult(
          status: EnrichmentRunStatus.cancelled,
          addedWords: added,
          targetWords: quota,
          sentencesAnalyzed: sentencesAnalyzed,
        );
      }

      final fetched = await tatoebaService.searchSentences(
        random: true,
        pageSize: batchSize,
      );
      batches++;

      if (fetched.isEmpty) {
        emptyFetches++;
        if (emptyFetches >= maxConsecutiveEmptyFetches || batches >= maxBatches) {
          return EnrichmentRunResult(
            status: EnrichmentRunStatus.networkError,
            addedWords: added,
            targetWords: quota,
            sentencesAnalyzed: sentencesAnalyzed,
            errorMessage:
                'Impossible de joindre Tatoeba. Ta progression est sauvegardée : '
                'relance « Enrichir mon niveau » pour reprendre.',
          );
        }
        continue;
      }
      emptyFetches = 0;

      // Toute phrase entrant dans le pipeline passe le filtre qualité :
      // admission par niveau, classement par pertinence, diversité des domaines.
      final sentences = qualityFilter.selectDiverseBatch(
        fetched,
        level: level,
        maxSentences: batchSize,
      );
      sentencesAnalyzed += sentences.length;
      report(added, sentencesAnalyzed);

      for (final sentence in sentences) {
        if (added >= remaining) break;
        if (isCancelled?.call() ?? false) break;

        final candidates = await tatoebaService.analyzeSentenceWords(
          sentence: sentence.textEn,
          wordRepository: wordRepository,
        );

        for (final candidate in candidates) {
          if (added >= remaining) break;
          if (candidate.estimatedLevel != level) continue;
          if (candidate.isAlreadyInDb) continue;
          if (!addedTerms.add(candidate.term)) continue;

          await _addWordFromCandidate(candidate, sentence, level);
          added++;
          report(added, sentencesAnalyzed);
        }
      }

      if (batches >= maxBatches && added < remaining) {
        return EnrichmentRunResult(
          status: EnrichmentRunStatus.sourceExhausted,
          addedWords: added,
          targetWords: quota,
          sentencesAnalyzed: sentencesAnalyzed,
          errorMessage:
              'Le volume de phrases disponibles a été atteint sans couvrir tout le '
              'quota. Les ajouts sont conservés : relance plus tard pour compléter.',
        );
      }
    }

    return EnrichmentRunResult(
      status: EnrichmentRunStatus.completed,
      addedWords: added,
      targetWords: quota,
      sentencesAnalyzed: sentencesAnalyzed,
    );
  }

  Future<void> _addWordFromCandidate(
    ExtractedCandidateWord candidate,
    TatoebaSentence sentence,
    CefrLevel level,
  ) async {
    var translation = candidate.translation ?? '';
    if (translation.isEmpty) {
      translation = await resolveTranslation(candidate.term);
    }
    if (translation.isEmpty) translation = 'Traduction à préciser';

    await wordRepository.addWord(
      term: candidate.term,
      translation: translation,
      contextSentence: sentence.textEn,
      category: candidate.suggestedCategory ?? 'Daily Life & Home',
      level: level.code,
      pos: candidate.pos ?? 'noun',
      frequencyScore: candidate.frequencyScore,
    );
  }
}
