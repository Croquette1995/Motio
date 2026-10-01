import 'package:dio/dio.dart';
import '../domain/word_details.dart';

class WiktionaryService {
  final Dio _dio;
  final Map<String, WordDetails> _cache = {};

  static const String defaultUserAgent = 'LexiFlow/1.0 (contact@lexiflow.app)';
  static const String baseRestUrl = 'https://en.wiktionary.org/api/rest_v1/';
  static const String actionApiUrl = 'https://en.wiktionary.org/w/api.php';

  WiktionaryService({Dio? dio})
      : _dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 5),
                receiveTimeout: const Duration(seconds: 5),
              ),
            ) {
    _dio.options.headers['User-Agent'] = defaultUserAgent;
  }

  /// Sanitize HTML string by stripping tags and unescaping common HTML entities.
  static String sanitizeHtml(String html) {
    if (html.isEmpty) return html;
    var clean = html.replaceAll(RegExp(r'<[^>]*>'), '');
    clean = clean
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return clean;
  }

  /// Clean wikitext markup for readable display.
  static String cleanWikitext(String text) {
    if (text.isEmpty) return text;
    var clean = text;

    // Remove category/file links
    clean = clean.replaceAll(RegExp(r'\[\[(?:Category|File):[^\]]+\]\]', caseSensitive: false), '');

    // Replace [[wiki link|display text]] -> display text
    clean = clean.replaceAllMapped(
      RegExp(r'\[\[(?:[^\|\]]+\|)?([^\]]+)\]\]'),
      (m) => m.group(1) ?? '',
    );

    // Extract term from {{t+|fr|term}} or {{t|fr|term}}
    clean = clean.replaceAllMapped(
      RegExp(r'\{\{t\+?\|[a-z]+\|([^\|\}]+)(?:\|[^\}]*)?\}\}'),
      (m) => m.group(1) ?? '',
    );

    // Extract term from {{l|en|term}}, {{m|la|term}}, {{der|en|la|term}}
    clean = clean.replaceAllMapped(
      RegExp(r'\{\{(?:l|m|der|inh|bor)\|[a-zA-Z\-]+\|(?:[a-zA-Z\-]+\|)?([^\|\}]+)(?:\|[^\}]*)?\}\}'),
      (m) => m.group(1) ?? '',
    );

    // Remove remaining templates
    clean = clean.replaceAll(RegExp(r'\{\{[^\}]+\}\}'), '');

    // Remove bold/italic markers
    clean = clean.replaceAll("'''", '').replaceAll("''", '');

    // Normalize spacing
    clean = clean.replaceAll(RegExp(r'\s+'), ' ').trim();
    return clean;
  }

  /// Fetch word details from Wiktionary API with cache & error handling.
  Future<WordDetails> fetchWordDetails(String rawTerm) async {
    final word = rawTerm.trim().toLowerCase();
    if (word.isEmpty) {
      return WordDetails(term: rawTerm);
    }

    if (_cache.containsKey(word)) {
      return _cache[word]!;
    }

    List<WordDefinition> definitions = [];
    String? etymology;
    List<String> synonyms = [];
    List<WordTranslation> translations = [];

    final encodedWord = Uri.encodeComponent(word);

    // 1. Fetch REST definitions
    try {
      final restResponse = await _dio.get('$baseRestUrl/page/definition/$encodedWord');

      if (restResponse.statusCode == 200 && restResponse.data is Map<String, dynamic>) {
        final Map<String, dynamic> data = restResponse.data;

        if (data.containsKey('en') && data['en'] is List) {
          final List enEntries = data['en'];
          for (final entry in enEntries) {
            if (entry is Map<String, dynamic>) {
              final partOfSpeech = entry['partOfSpeech'] as String? ?? 'Inconnu';
              final defsList = entry['definitions'];

              if (defsList is List) {
                for (final def in defsList) {
                  if (def is Map<String, dynamic>) {
                    final rawDef = def['definition'] as String? ?? '';
                    final cleanDef = sanitizeHtml(rawDef);

                    if (cleanDef.isNotEmpty) {
                      String? example;
                      if (def['parsedExamples'] is List && (def['parsedExamples'] as List).isNotEmpty) {
                        final exObj = (def['parsedExamples'] as List).first;
                        if (exObj is Map<String, dynamic> && exObj['example'] is String) {
                          example = sanitizeHtml(exObj['example']);
                        }
                      } else if (def['examples'] is List && (def['examples'] as List).isNotEmpty) {
                        final exStr = (def['examples'] as List).first;
                        if (exStr is String) {
                          example = sanitizeHtml(exStr);
                        }
                      }

                      definitions.add(
                        WordDefinition(
                          partOfSpeech: partOfSpeech,
                          text: cleanDef,
                          example: example?.isNotEmpty == true ? example : null,
                        ),
                      );
                    }
                  }
                }
              }
            }
          }
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // Word not found in REST API
        final emptyDetails = WordDetails(term: word);
        _cache[word] = emptyDetails;
        return emptyDetails;
      }
      // Non-404 network error: continue to fallback or return empty
    } catch (_) {
      // Ignore parsing errors and fallback gracefully
    }

    // 2. Fetch Wikitext via Action API for Etymology, Synonyms & Translations
    try {
      final actionResponse = await _dio.get(
        actionApiUrl,
        queryParameters: {
          'action': 'parse',
          'page': word,
          'prop': 'wikitext',
          'format': 'json',
        },
      );

      if (actionResponse.statusCode == 200 && actionResponse.data is Map<String, dynamic>) {
        final parseObj = actionResponse.data['parse'];
        if (parseObj is Map<String, dynamic> && parseObj['wikitext'] is Map<String, dynamic>) {
          final wikitext = parseObj['wikitext']['*'] as String? ?? '';

          if (wikitext.isNotEmpty) {
            // Parse Etymology
            final etymMatch = RegExp(r'===Etymology===\s*\n([\s\S]*?)(?=\n===|\n==|\Z)').firstMatch(wikitext);
            if (etymMatch != null) {
              final rawEtym = etymMatch.group(1) ?? '';
              final cleanedEtym = cleanWikitext(rawEtym);
              if (cleanedEtym.isNotEmpty) {
                etymology = cleanedEtym;
              }
            }

            // Parse Synonyms
            final synMatch = RegExp(r'====Synonyms====\s*\n([\s\S]*?)(?=\n====|\n===|\n==|\Z)').firstMatch(wikitext);
            if (synMatch != null) {
              final rawSynBlock = synMatch.group(1) ?? '';
              final synLines = rawSynBlock.split('\n');
              final Set<String> synSet = {};

              for (final line in synLines) {
                // Match {{l|en|synonym}} or {{syn|en|synonym}} or bullet points
                final matches = RegExp(r'\{\{(?:l|m|syn)\|en\|([^\|\}]+)').allMatches(line);
                for (final m in matches) {
                  final syn = m.group(1)?.trim();
                  if (syn != null && syn.isNotEmpty) {
                    synSet.add(syn);
                  }
                }
                // Bullet points like * [[synonym]]
                if (matches.isEmpty && line.trim().startsWith('*')) {
                  final cleanLine = cleanWikitext(line);
                  if (cleanLine.isNotEmpty && cleanLine != '*') {
                    synSet.add(cleanLine.replaceAll(RegExp(r'^\*\s*'), ''));
                  }
                }
              }
              synonyms = synSet.toList();
            }

            // Parse French Translations
            final Set<String> frTransSet = {};
            final frMatches = RegExp(r'\{\{t\+?\|fr\|([^\|\}]+)').allMatches(wikitext);
            for (final m in frMatches) {
              final term = m.group(1)?.trim();
              if (term != null && term.isNotEmpty) {
                frTransSet.add(term);
              }
            }
            translations = frTransSet
                .map((t) => WordTranslation(language: 'Français', term: t))
                .toList();
          }
        }
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404 && definitions.isEmpty) {
        final emptyDetails = WordDetails(term: word);
        _cache[word] = emptyDetails;
        return emptyDetails;
      }
    } catch (_) {
      // Ignore secondary parsing errors
    }

    final result = WordDetails(
      term: word,
      definitions: definitions,
      etymology: etymology,
      synonyms: synonyms,
      translations: translations,
    );

    _cache[word] = result;
    return result;
  }

  /// Get cached word details if available.
  WordDetails? getCachedDetails(String rawTerm) {
    final word = rawTerm.trim().toLowerCase();
    return _cache[word];
  }

  /// Clear in-memory cache.
  void clearCache() {
    _cache.clear();
  }
}
