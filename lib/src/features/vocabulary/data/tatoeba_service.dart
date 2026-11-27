import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/i_word_repository.dart';
import '../domain/sentence_quality_filter.dart';
import '../domain/tatoeba_sentence.dart';
import '../domain/word_categorizer_service.dart';
import '../domain/lemmatizer.dart';
import '../domain/word_frequency_service.dart';

final tatoebaServiceProvider = Provider<TatoebaService>((ref) {
  return TatoebaService();
});

class TatoebaService {
  final Dio _dio;
  final WordFrequencyService _frequencyService;
  final WordCategorizerService _categorizerService;

  static const String baseUrl = 'https://tatoeba.org/en/api_v0';
  static const String userAgent = 'LexiFlow/1.0 (https://github.com/cchiodo/Motio)';

  /// Stopwords anglais canoniques (définis dans le filtre qualité, Issue 28).
  static const Set<String> englishStopwords = SentenceQualityFilter.englishStopwords;

  TatoebaService({
    Dio? dio,
    WordFrequencyService frequencyService = const WordFrequencyService(),
    WordCategorizerService categorizerService = const WordCategorizerService(),
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 8),
                headers: {'User-Agent': userAgent},
              ),
            ),
        _frequencyService = frequencyService,
        _categorizerService = categorizerService;

  /// Recherche des phrases bilingues sur Tatoeba (sans clé API)
  Future<List<TatoebaSentence>> searchSentences({
    String from = 'eng',
    String to = 'fra',
    String query = '',
    bool random = true,
    int pageSize = 5,
    int wordCountMin = 3,
    int wordCountMax = 12,
  }) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'from': from,
          'to': to,
          if (query.trim().isNotEmpty) 'query': query.trim(),
          'trans_filter': 'limit',
          'trans_to': to,
          'sort': random ? 'random' : 'relevance',
          'pageSize': pageSize,
          'word_count_min': wordCountMin,
          'word_count_max': wordCountMax,
          'orphans': 'no',
          'unapproved': 'no',
        },
      );

      if (response.statusCode != 200 || response.data is! Map<String, dynamic>) {
        return [];
      }

      final results = response.data['results'];
      if (results is! List) return [];

      final List<TatoebaSentence> sentences = [];

      for (final item in results) {
        if (item is Map<String, dynamic>) {
          final id = item['id'] as int? ?? 0;
          final textEn = item['text'] as String? ?? '';
          final license = item['license'] as String? ?? 'CC BY 2.0 FR';

          String textFr = '';
          final translations = item['translations'];
          if (translations is List && translations.isNotEmpty) {
            for (final group in translations) {
              if (group is List && group.isNotEmpty) {
                final firstTrans = group.first;
                if (firstTrans is Map<String, dynamic>) {
                  final candidateFr = firstTrans['text'] as String? ?? '';
                  if (candidateFr.isNotEmpty) {
                    textFr = candidateFr;
                    break;
                  }
                }
              }
            }
          }

          final audio = _parseAudio(item);
          if (textEn.isNotEmpty && textFr.isNotEmpty) {
            sentences.add(
              TatoebaSentence(
                id: id,
                textEn: textEn,
                textFr: textFr,
                audioUrl: audio.$1,
                hasAudio: audio.$2,
                license: license,
              ),
            );
          }
        }
      }

      return sentences;
    } catch (_) {
      return [];
    }
  }

  /// Extrait la présence d'audio et son URL de téléchargement depuis la
  /// réponse de l'API Tatoeba (champ `audios`).
  (String?, bool) _parseAudio(Map<String, dynamic> item) {
    final audios = item['audios'];
    if (audios is! List || audios.isEmpty) return (null, false);

    for (final audio in audios) {
      if (audio is! Map<String, dynamic>) continue;
      final download = audio['download_url'] as String?;
      if (download == null || download.isEmpty) continue;
      final url = download.startsWith('http') ? download : 'https://tatoeba.org$download';
      return (url, true);
    }
    return (null, false);
  }

  /// Recherche des phrases d'exemples spécifiques pour un mot donné sur Tatoeba (Zero Clé API)
  Future<List<TatoebaSentence>> getExamplesForWord({
    required String word,
    String from = 'eng',
    String to = 'fra',
    int limit = 10,
    bool random = false,
  }) async {
    final clean = word.trim();
    if (clean.isEmpty) return [];

    return searchSentences(
      from: from,
      to: to,
      query: clean,
      random: random,
      pageSize: limit,
      wordCountMin: 3,
      wordCountMax: 20,
    );
  }

  /// Découpe une phrase en mots candidats uniques en ignorant les stopwords ;
  /// dédoublonnage par lemme (Issue 32) : la première forme de surface gagne.
  List<String> extractCandidateTokens(String sentence, {String language = 'en'}) {
    if (sentence.isEmpty) return [];

    // Normaliser et séparer les mots
    final tokens = sentence
        .toLowerCase()
        .replaceAll(RegExp(r"[^\w\s\-]"), ' ')
        .split(RegExp(r'\s+'))
        .map((w) => w.replaceAll(RegExp(r'^-+|-+$'), '').trim())
        .where((w) => w.length >= 2 && !RegExp(r'^\d+$').hasMatch(w))
        .toList();

    final List<String> candidates = [];
    final seenLemmas = <String>{};

    for (final token in tokens) {
      if (englishStopwords.contains(token)) continue;
      // Dédoublonnage par lemme (« dog » et « dogs » ne comptent qu'une fois) ;
      // la forme de surface est conservée pour l'affichage.
      if (seenLemmas.add(lemmatize(token, language: language))) {
        candidates.add(token);
      }
    }

    return candidates;
  }

  /// Analyse les mots de la phrase, vérifie l'existence dans la base Drift,
  /// estime leur niveau CECRL par fréquence Zipf et infère la catégorie sémantique.
  Future<List<ExtractedCandidateWord>> analyzeSentenceWords({
    required String sentence,
    required IWordRepository wordRepository,
    String language = 'en',
  }) async {
    // Amorce le chargement de la wordlist embarquée de la langue apprise
    // (Issue 31) ; no-op si déjà en cache. Non bloquant (voir runToQuota).
    unawaited(WordFrequencyService.preloadLanguage(language));
    final tokens = extractCandidateTokens(sentence, language: language);
    final List<ExtractedCandidateWord> candidates = [];

    for (final token in tokens) {
      final inDb = await wordRepository.wordExists(token, language: language);
      final score = _frequencyService.getFrequencyScore(token, language: language);
      final level = _frequencyService.determineLevel(token, language: language);
      final category = _categorizerService.categorizeWord(token, contextSentence: sentence);

      candidates.add(
        ExtractedCandidateWord(
          term: token,
          frequencyScore: score,
          estimatedLevel: level,
          isAlreadyInDb: inDb,
          suggestedCategory: category,
        ),
      );
    }

    return candidates;
  }
}
