import 'package:dio/dio.dart';
import '../domain/i_word_repository.dart';
import '../domain/tatoeba_sentence.dart';
import '../domain/word_frequency_service.dart';

class TatoebaService {
  final Dio _dio;
  final WordFrequencyService _frequencyService;

  static const String baseUrl = 'https://tatoeba.org/en/api_v0';
  static const String userAgent = 'LexiFlow/1.0 (https://github.com/cchiodo/Motio)';

  static const Set<String> englishStopwords = {
    'the', 'a', 'an', 'and', 'or', 'but', 'if', 'because', 'as', 'until', 'while',
    'of', 'at', 'by', 'for', 'with', 'about', 'against', 'between', 'into', 'through',
    'during', 'before', 'after', 'above', 'below', 'to', 'from', 'up', 'down', 'in',
    'out', 'on', 'off', 'over', 'under', 'again', 'further', 'then', 'once', 'here',
    'there', 'when', 'where', 'why', 'how', 'all', 'any', 'both', 'each', 'few',
    'more', 'most', 'other', 'some', 'such', 'no', 'nor', 'not', 'only', 'own',
    'same', 'so', 'than', 'too', 'very', 's', 't', 'can', 'will', 'just', 'don',
    'should', 'now', 'd', 'll', 'm', 'o', 're', 've', 'y', 'ain', 'aren',
    'couldn', 'didn', 'doesn', 'hadn', 'hasn', 'haven', 'isn', 'ma', 'mightn',
    'mustn', 'needn', 'shan', 'shouldn', 'wasn', 'weren', 'won', 'wouldn',
    'i', 'me', 'my', 'myself', 'we', 'our', 'ours', 'ourselves', 'you', 'your',
    'yours', 'yourself', 'yourselves', 'he', 'him', 'his', 'himself', 'she', 'her',
    'hers', 'herself', 'it', 'its', 'itself', 'they', 'them', 'their', 'theirs',
    'themselves', 'what', 'which', 'who', 'whom', 'this', 'that', 'these', 'those',
    'am', 'is', 'are', 'was', 'were', 'be', 'been', 'being', 'have', 'has', 'had',
    'having', 'do', 'does', 'did', 'doing', 'would', 'could', 'shall'
  };

  TatoebaService({
    Dio? dio,
    WordFrequencyService frequencyService = const WordFrequencyService(),
  })  : _dio = dio ??
            Dio(
              BaseOptions(
                baseUrl: baseUrl,
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 8),
                headers: {'User-Agent': userAgent},
              ),
            ),
        _frequencyService = frequencyService;

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

          if (textEn.isNotEmpty && textFr.isNotEmpty) {
            sentences.add(
              TatoebaSentence(
                id: id,
                textEn: textEn,
                textFr: textFr,
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

  /// Découpe une phrase en mots candidats uniques en ignorant les stopwords
  List<String> extractCandidateTokens(String sentence) {
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
    final seen = <String>{};

    for (final token in tokens) {
      if (!englishStopwords.contains(token) && seen.add(token)) {
        candidates.add(token);
      }
    }

    return candidates;
  }

  /// Analyse les mots de la phrase, vérifie l'existence dans la base Drift
  /// et estime leur niveau CECRL par fréquence Zipf.
  Future<List<ExtractedCandidateWord>> analyzeSentenceWords({
    required String sentence,
    required IWordRepository wordRepository,
    String language = 'en',
  }) async {
    final tokens = extractCandidateTokens(sentence);
    final List<ExtractedCandidateWord> candidates = [];

    for (final token in tokens) {
      final inDb = await wordRepository.wordExists(token, language: language);
      final score = _frequencyService.getFrequencyScore(token, language: language);
      final level = _frequencyService.determineLevel(token, language: language);

      candidates.add(
        ExtractedCandidateWord(
          term: token,
          frequencyScore: score,
          estimatedLevel: level,
          isAlreadyInDb: inDb,
        ),
      );
    }

    return candidates;
  }
}
