import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/vocabulary/data/wiktionary_service.dart';

void main() {
  group('WiktionaryService Helper Functions', () {
    test('sanitizeHtml removes HTML tags and decodes entities', () {
      const html = '<p>To <b>leave</b> behind &amp; &quot;forsake&quot;</p>';
      final clean = WiktionaryService.sanitizeHtml(html);
      expect(clean, equals('To leave behind & "forsake"'));
    });

    test('cleanWikitext cleans wiki markup, templates, and formatting', () {
      const wikitext = "From {{der|en|la|resiliēns}} '''rebounding'''. {{l|en|flexible}}";
      final clean = WiktionaryService.cleanWikitext(wikitext);
      expect(clean, contains('resiliēns'));
      expect(clean, contains('rebounding'));
    });
  });

  group('WiktionaryService API and Cache', () {
    late Dio dio;
    late WiktionaryService service;

    setUp(() {
      dio = Dio();
      service = WiktionaryService(dio: dio);
    });

    test('fetchWordDetails normalizes term and uses User-Agent header', () async {
      int requestCount = 0;
      String? userAgentHeader;

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            requestCount++;
            userAgentHeader = options.headers['User-Agent'];

            if (options.path.contains('/page/definition/')) {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'en': [
                      {
                        'partOfSpeech': 'Verb',
                        'definitions': [
                          {
                            'definition': 'To <b>abandon</b> something',
                            'examples': ['He abandoned his car.'],
                          }
                        ]
                      }
                    ]
                  },
                ),
              );
            } else {
              return handler.resolve(
                Response(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'parse': {
                      'wikitext': {
                        '*': '===Etymology===\nFrom French abandonner.\n====Synonyms====\n* {{l|en|forsake}}\n====Translations====\n* {{t+|fr|abandonner}}'
                      }
                    }
                  },
                ),
              );
            }
          },
        ),
      );

      final details = await service.fetchWordDetails('  ABANDON  ');

      expect(details.term, equals('abandon'));
      expect(userAgentHeader, equals(WiktionaryService.defaultUserAgent));
      expect(details.definitions.length, equals(1));
      expect(details.definitions.first.partOfSpeech, equals('Verb'));
      expect(details.definitions.first.text, equals('To abandon something'));
      expect(details.definitions.first.example, equals('He abandoned his car.'));
      expect(details.etymology, contains('abandonner'));
      expect(details.synonyms, contains('forsake'));
      expect(details.translations.first.term, equals('abandonner'));

      // Test Cache: Second call with same term should return cached result without new HTTP requests
      final initialRequestCount = requestCount;
      final cachedDetails = await service.fetchWordDetails('abandon');

      expect(requestCount, equals(initialRequestCount));
      expect(cachedDetails, equals(details));
    });

    test('fetchWordDetails handles 404 gracefully', () async {
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            return handler.reject(
              DioException(
                requestOptions: options,
                response: Response(
                  requestOptions: options,
                  statusCode: 404,
                ),
                type: DioExceptionType.badResponse,
              ),
            );
          },
        ),
      );

      final details = await service.fetchWordDetails('unknownwordxyz');

      expect(details.term, equals('unknownwordxyz'));
      expect(details.isEmpty, isTrue);
    });
  });
}
