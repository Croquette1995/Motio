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

  /// Extract the English section from complete Wiktionary page wikitext.
  /// Protects against extracting foreign language synonyms, etymologies, or definitions.
  static String extractEnglishSection(String wikitext) {
    if (wikitext.isEmpty) return wikitext;
    final match = RegExp(r'==English==\s*\n([\s\S]*?)(?=\n==[^=]|$)').firstMatch(wikitext);
    return match != null ? (match.group(1) ?? wikitext) : wikitext;
  }

  /// Clean wikitext markup for readable display.
  static String cleanWikitext(String text) {
    if (text.isEmpty) return text;
    var clean = text;

    // Remove <ref>...</ref> and <ref ... />
    clean = clean.replaceAll(RegExp(r'<ref[^>]*>[\s\S]*?</ref>', caseSensitive: false), '');
    clean = clean.replaceAll(RegExp(r'<ref[^/>]*/>', caseSensitive: false), '');

    // Remove HTML tags
    clean = clean.replaceAll(RegExp(r'<[^>]*>'), '');

    // Remove category/file links
    clean = clean.replaceAll(RegExp(r'\[\[(?:Category|File):[^\]]+\]\]', caseSensitive: false), '');

    // Replace [[wiki link|display text]] -> display text or [[text]] -> text
    clean = clean.replaceAllMapped(
      RegExp(r'\[\[(?:[^\|\]]+\|)?([^\]]+)\]\]'),
      (m) => m.group(1) ?? '',
    );

    // Extract term from {{compound|en|word1|word2}} or {{surf|en|w1|w2}} -> word1 + word2
    clean = clean.replaceAllMapped(
      RegExp(r'\{\{(?:compound|surf)\|[a-zA-Z\-]+\|([^\|\}]+)\|([^\|\}]+)(?:\|[^\}]*)?\}\}'),
      (m) => '${m.group(1) ?? ""} + ${m.group(2) ?? ""}',
    );

    // Extract term from {{back-formation|en|term}} -> back-formation from term
    clean = clean.replaceAllMapped(
      RegExp(r'\{\{back-formation\|[a-zA-Z\-]+\|([^\|\}]+)(?:\|[^\}]*)?\}\}'),
      (m) => 'back-formation from ${m.group(1) ?? ""}',
    );

    // Extract term from {{ety|en|...}}
    clean = clean.replaceAllMapped(
      RegExp(r'\{\{ety\|[a-zA-Z\-]+\|([^\}]+)\}\}'),
      (m) {
        final args = (m.group(1) ?? '').split('|');
        final terms = <String>[];
        for (final a in args) {
          if (a.startsWith(':') || a.startsWith('text=') || a.startsWith('tree=') || a.startsWith('id=')) {
            continue;
          }
          var cleanArg = a.replaceAll(RegExp(r'<[^>]+>'), '');
          if (cleanArg.contains(':')) {
            cleanArg = cleanArg.split(':').last;
          }
          cleanArg = cleanArg.trim();
          if (cleanArg.isNotEmpty) {
            terms.add(cleanArg);
          }
        }
        return terms.join(' + ');
      },
    );

    // Extract term from {{t+|fr|term}} or {{t|fr|term}}
    clean = clean.replaceAllMapped(
      RegExp(r'\{\{t\+?\|[a-z]+\|([^\|\}]+)(?:\|[^\}]*)?\}\}'),
      (m) => m.group(1) ?? '',
    );

    // Extract term from {{l|en|term}}, {{m|la|term}}, {{der|en|la|term}}, {{bor|...}}, {{inh|...}}, {{cog|...}}
    clean = clean.replaceAllMapped(
      RegExp(r'\{\{(?:l|m|der|inh|bor|cog)\|[a-zA-Z\-]+\|(?:[a-zA-Z\-]+\|)?([^\|\}]+)(?:\|[^\}]*)?\}\}'),
      (m) => m.group(1) ?? '',
    );

    // Remove remaining templates
    clean = clean.replaceAll(RegExp(r'\{\{[^\}]+\}\}'), '');

    // Remove bold/italic markers
    clean = clean.replaceAll("'''", '').replaceAll("''", '');

    // Normalize spacing and clean dangling punctuation
    clean = clean.replaceAll(RegExp(r'\s+'), ' ').trim();
    clean = clean.replaceAll(RegExp(r'^[\s;.,]+|[\s;.,]+$'), '');
    return clean;
  }

  /// Parse etymology text from English wikitext supporting ===Etymology=== and ===Etymology 1===.
  static String? parseEtymology(String enWikitext) {
    final matches = RegExp(r'===Etymology(?:\s*\d+)?===\s*\n([\s\S]*?)(?=\n===|\n==|$)')
        .allMatches(enWikitext);
    final etymList = <String>[];
    for (final match in matches) {
      final raw = match.group(1) ?? '';
      final cleaned = cleanWikitext(raw);
      if (cleaned.isNotEmpty && !etymList.contains(cleaned)) {
        etymList.add(cleaned);
      }
    }
    return etymList.isNotEmpty ? etymList.join(' | ') : null;
  }

  /// Parse synonyms from English wikitext including inline {{syn|en|...}} and ===+Synonyms===+ sections.
  static List<String> parseSynonyms(String enWikitext) {
    final synSet = <String>{};

    // 1. Match inline {{syn|en|...}} and {{nearsyn|en|...}} and {{synonyms|en|...}}
    final inlineMatches = RegExp(r'\{\{(?:syn|nearsyn|synonyms)\|en\|([^\}]+)\}\}')
        .allMatches(enWikitext);
    for (final m in inlineMatches) {
      final inner = m.group(1) ?? '';
      final parts = inner.split('|');
      for (final p in parts) {
        if (p.startsWith('qq:') || p.startsWith('t:') || p.startsWith('q:') || p.contains('=')) {
          continue;
        }
        var cleanTerm = p.split('#').first.trim();
        cleanTerm = cleanTerm.replaceAll(RegExp(r'<[^>]+>'), '').trim();
        if (cleanTerm.isNotEmpty && !cleanTerm.startsWith(':')) {
          synSet.add(cleanTerm);
        }
      }
    }

    // 2. Match ===+Synonyms===+ sections
    final sectionMatches = RegExp(r'={3,5}Synonyms={3,5}\s*\n([\s\S]*?)(?=\n={2,5}|$)')
        .allMatches(enWikitext);
    for (final m in sectionMatches) {
      final block = m.group(1) ?? '';
      for (final line in block.split('\n')) {
        final trimmed = line.trim();
        if (trimmed.isEmpty) continue;

        // Match {{l|en|synonym}} or {{syn|en|synonym}}
        final lMatches = RegExp(r'\{\{(?:l|m|syn)\|en\|([^\|\}]+)').allMatches(trimmed);
        for (final lm in lMatches) {
          final t = (lm.group(1) ?? '').split('#').first.trim();
          if (t.isNotEmpty) synSet.add(t);
        }

        // Bullet points like * [[synonym]]
        if (trimmed.startsWith('*')) {
          var cleanLine = cleanWikitext(trimmed);
          cleanLine = cleanLine.replaceAll(RegExp(r'^\*\s*'), '').trim();
          if (cleanLine.isNotEmpty && cleanLine != '*') {
            for (final sub in cleanLine.split(',')) {
              final s = sub.trim();
              if (s.isNotEmpty && s.length < 50) {
                synSet.add(s);
              }
            }
          }
        }
      }
    }

    return synSet.toList();
  }

  /// Parse French translations from English section wikitext.
  static List<WordTranslation> parseTranslations(String enWikitext) {
    final frTransSet = <String>{};
    final frMatches = RegExp(r'\{\{t\+?\|fr\|([^\|\}]+)').allMatches(enWikitext);
    for (final m in frMatches) {
      final term = m.group(1)?.trim();
      if (term != null && term.isNotEmpty) {
        frTransSet.add(term);
      }
    }
    return frTransSet
        .map((t) => WordTranslation(language: 'Français', term: t))
        .toList();
  }

  /// Helper to parse REST API definition list.
  List<WordDefinition> _parseRestDefinitions(Map<String, dynamic> data) {
    final List<WordDefinition> defs = [];
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

                  defs.add(
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
    return defs;
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
        definitions = _parseRestDefinitions(restResponse.data);
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        // If not found in REST API, continue to Action API (might be inflected form / wikitext)
      }
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
          final rawWikitext = parseObj['wikitext']['*'] as String? ?? '';

          if (rawWikitext.isNotEmpty) {
            // Isolate English section to avoid foreign language pollution
            final enWikitext = extractEnglishSection(rawWikitext);

            // Parse Etymology
            etymology = parseEtymology(enWikitext);

            // Parse Synonyms
            synonyms = parseSynonyms(enWikitext);

            // Parse French Translations
            translations = parseTranslations(enWikitext);

            // 3. Fallback for inflected forms (e.g. plural of accommodation)
            if (definitions.isEmpty) {
              final pluralMatch = RegExp(r'\{\{(?:plural of|en-plural of|inflection of)\|en\|([a-zA-Z\-]+)')
                  .firstMatch(enWikitext);
              if (pluralMatch != null) {
                final lemma = pluralMatch.group(1)?.toLowerCase();
                if (lemma != null && lemma != word) {
                  try {
                    final lemmaRest = await _dio.get('$baseRestUrl/page/definition/$lemma');
                    if (lemmaRest.statusCode == 200 && lemmaRest.data is Map<String, dynamic>) {
                      definitions = _parseRestDefinitions(lemmaRest.data);
                    }
                  } catch (_) {}
                }
              }
            }
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
