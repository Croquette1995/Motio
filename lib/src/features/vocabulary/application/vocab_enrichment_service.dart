import 'dart:async';

import '../../settings/domain/cefr_level.dart';
import '../data/tatoeba_service.dart';
import '../domain/word_frequency_service.dart';
import '../data/wiktionary_service.dart';
import '../domain/i_word_repository.dart';
import '../domain/lemmatizer.dart';
import '../domain/sentence_quality_filter.dart';
import '../domain/tatoeba_sentence.dart';
import '../domain/word_categorizer_service.dart';

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

  /// Traduction française d'un terme, résolue sur le Wiktionnaire : forme de
  /// surface puis lemme (« made » → « make »). Sans traduction française, le
  /// mot reste à préciser plutôt que d'enregistrer une définition anglaise.
  Future<String> resolveTranslation(String term) async {
    final external = _externalTranslationResolver;
    if (external != null) return external(term);

    final clean = term.trim().toLowerCase();
    final lemma = lemmatize(clean);
    final lookups =
        lemma.isNotEmpty && lemma != clean ? [clean, lemma] : [clean];
    for (final lookup in lookups) {
      try {
        final details = await wiktionaryService.fetchWordDetails(lookup);
        for (final translation in details.translations) {
          final fr = translation.term.trim();
          if (fr.isNotEmpty) return fr;
        }
      } catch (_) {
        // La traduction sera complétée manuellement plus tard.
      }
    }
    return 'Traduction à préciser';
  }

  /// Pipeline automatique d'enrichissement, boucle query-first (Issue 33) :
  /// les mots-cibles manquants du niveau actif (wordlist embarquée Issue 31,
  /// round-robin par domaine) sont servis en priorité via des requêtes Tatoeba
  /// ciblées, avec une part de tirage aléatoire conservée (1 lot aléatoire
  /// tous les [randomBatchEvery] lots ciblés). Extraction des mots ->
  /// déduction du niveau (Zipf) -> ajout sans doublon -> progression remontée
  /// en continu, jusqu'au quota.
  ///
  /// Parking : un mot-cible sans phrase acceptable est essayé une fois puis
  /// mis de côté ; [EnrichmentRunStatus.sourceExhausted] n'arrive qu'une fois
  /// toutes les cibles du run essayées (ou [maxBatches] lots consommés).
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
    int maxBatches = 800,
    int randomBatchEvery = 5,
    int? quotaOverride,
    String language = 'en',
  }) async {
    final quota = quotaOverride ?? levelQuota(level);

    // Amorce le chargement de la wordlist embarquée de la langue apprise
    // (Issue 31) ; no-op si déjà en cache. Non bloquant : la lecture d'asset
    // se termine bien avant la première analyse de phrase (fetch réseau).
    unawaited(WordFrequencyService.preloadLanguage(language));
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
    var batchesSinceRandom = 0;
    final addedTerms = <String>{};
    final storedTerms = <String>{};

    report(added, sentencesAnalyzed);

    final targetQueue = await _buildTargetQueue(level, language: language);

    while (added < remaining) {
      if (isCancelled?.call() ?? false) {
        return EnrichmentRunResult(
          status: EnrichmentRunStatus.cancelled,
          addedWords: added,
          targetWords: quota,
          sentencesAnalyzed: sentencesAnalyzed,
        );
      }
      if (batches >= maxBatches) {
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

      // Query-first : priorité aux mots-cibles manquants du niveau actif ;
      // un lot aléatoire est glissé périodiquement (tirage conservé).
      final useRandomBatch =
          randomBatchEvery > 0 && batchesSinceRandom >= randomBatchEvery;
      List<TatoebaSentence> fetched;
      if (!useRandomBatch && targetQueue.isNotEmpty) {
        final target = targetQueue.removeAt(0);
        fetched = await tatoebaService.getExamplesForWord(
          word: target,
          limit: batchSize,
        );
        batchesSinceRandom++;
      } else {
        fetched = await tatoebaService.searchSentences(
          random: true,
          pageSize: batchSize,
        );
        batchesSinceRandom = 0;
      }
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
        language: language,
      );
      sentencesAnalyzed += sentences.length;
      report(added, sentencesAnalyzed);

      for (final sentence in sentences) {
        if (added >= remaining) break;
        if (isCancelled?.call() ?? false) break;

        final candidates = await tatoebaService.analyzeSentenceWords(
          sentence: sentence.textEn,
          wordRepository: wordRepository,
          language: language,
        );

        for (final candidate in candidates) {
          if (added >= remaining) break;
          if (candidate.estimatedLevel != level) continue;
          if (candidate.isAlreadyInDb) continue;
          if (!addedTerms.add(candidate.term)) continue;

          final stored = await _addWordFromCandidate(
            candidate,
            sentence,
            level,
            storedTerms: storedTerms,
            language: language,
          );
          if (!stored) continue;
          added++;
          report(added, sentencesAnalyzed);
        }
      }

    }

    return EnrichmentRunResult(
      status: EnrichmentRunStatus.completed,
      addedWords: added,
      targetWords: quota,
      sentencesAnalyzed: sentencesAnalyzed,
    );
  }

  /// File de mots-cibles query-first (Issue 33) : mots du niveau actif dans la
  /// wordlist embarquée, absents de la base (forme de surface ou lemme), hors
  /// mots vides, ordonnés en round-robin par domaine sémantique pour garder la
  /// diversité thématique des lots.
  Future<List<String>> _buildTargetQueue(
    CefrLevel level, {
    required String language,
  }) async {
    final knownForms = <String>{};
    for (final word in await wordRepository.getAllWords()) {
      final term = word.term.trim().toLowerCase();
      if (term.isEmpty) continue;
      knownForms.add(term);
      knownForms.add(lemmatize(term, language: language));
      final lemma = word.lemma?.trim().toLowerCase();
      if (lemma != null && lemma.isNotEmpty) knownForms.add(lemma);
    }

    const frequencyService = WordFrequencyService();
    // Les contractions (it's, don't…) sont exclues : l'extraction de candidats
    // sépare l'apostrophe, elles ne seraient jamais retrouvées dans une phrase.
    final seenLemmas = <String>{};
    final candidates = frequencyService.wordsAtLevel(level, language: language)
        .where((word) => !SentenceQualityFilter.englishStopwords.contains(word))
        .where((word) => !word.contains("'") && !word.contains("’"))
        .where((word) =>
            !knownForms.contains(word) &&
            !knownForms.contains(lemmatize(word, language: language)))
        // Une seule cible par lemme : la fiche est de toute façon créée sur
        // le lemme, « make » et « made » ne valent qu'une requête.
        .where((word) => seenLemmas.add(lemmatize(word, language: language)))
        .toList();

    final byDomain = <String, List<String>>{};
    const categorizer = WordCategorizerService();
    for (final word in candidates) {
      byDomain.putIfAbsent(categorizer.categorizeWord(word), () => []).add(word);
    }

    final domainQueues = byDomain.values.toList(growable: false);
    final ordered = <String>[];
    for (var rank = 0; ordered.length < candidates.length; rank++) {
      for (final queue in domainQueues) {
        if (rank < queue.length) ordered.add(queue[rank]);
      }
    }
    return ordered;
  }

  /// Crée la fiche d'un candidat sur son lemme (« made » → « make ») : la
  /// forme fléchie reste visible dans la phrase d'exemple de la carte.
  /// Renvoie false si une fiche du même lemme a déjà été créée pendant le run.
  Future<bool> _addWordFromCandidate(
    ExtractedCandidateWord candidate,
    TatoebaSentence sentence,
    CefrLevel level, {
    required Set<String> storedTerms,
    String language = 'en',
  }) async {
    final term = candidate.term.trim().toLowerCase();
    final lemma = lemmatize(term, language: language);
    final cardTerm = lemma != term ? lemma : term;
    if (!storedTerms.add(cardTerm)) return false;

    var translation = candidate.translation ?? '';
    if (translation.isEmpty) {
      translation = await resolveTranslation(cardTerm);
    }
    if (translation.isEmpty) translation = 'Traduction à préciser';

    await wordRepository.addWord(
      term: cardTerm,
      translation: translation,
      contextSentence: sentence.textEn,
      category: candidate.suggestedCategory ?? 'Daily Life & Home',
      level: level.code,
      pos: candidate.pos ?? 'noun',
      frequencyScore: candidate.frequencyScore,
      lemma: lemma,
    );
    return true;
  }
}
