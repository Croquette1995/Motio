import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/core/theme/bauhaus_theme.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/data/tatoeba_service.dart';
import 'package:lexiflow/src/features/vocabulary/domain/tatoeba_sentence.dart';
import 'package:lexiflow/src/features/vocabulary/presentation/tatoeba_explorer_controller.dart';
import 'package:lexiflow/src/features/vocabulary/presentation/tatoeba_explorer_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _StubTatoebaService extends TatoebaService {
  _StubTatoebaService(this.sentences);

  final List<TatoebaSentence> sentences;

  @override
  Future<List<TatoebaSentence>> searchSentences({
    String from = 'eng',
    String to = 'fra',
    String query = '',
    bool random = true,
    int pageSize = 5,
    int wordCountMin = 3,
    int wordCountMax = 12,
  }) async =>
      sentences;
}

void main() {
  late AppDatabase testDb;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();
  });

  tearDown(() async {
    await testDb.close();
  });

  // 'water' -> A1 (Zipf 5.8), 'station' -> A2 (Zipf 4.8), 'feedback' -> B1 (Zipf 4.3)
  // L'analyse réelle (Zipf) est réutilisée via TatoebaService.analyzeSentenceWords.
  const stubSentence = TatoebaSentence(
    id: 42,
    textEn: 'water station feedback',
    textFr: 'eau gare retour',
  );

  test('fetchSentences filters extracted candidates to the active level', () async {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(testDb),
        tatoebaServiceProvider.overrideWithValue(_StubTatoebaService([stubSentence])),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(tatoebaExplorerProvider.notifier);
    await notifier.fetchSentences();

    final state = container.read(tatoebaExplorerProvider);
    expect(state.candidates.map((c) => c.term), ['water']);
    expect(state.candidates.every((c) => c.estimatedLevel == CefrLevel.a1), isTrue);
  });

  test('selectSentence filters extracted candidates to the active level', () async {
    final a2Sentence = const TatoebaSentence(
      id: 43,
      textEn: 'station feedback water',
      textFr: 'gare retour eau',
    );
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(testDb),
        tatoebaServiceProvider
            .overrideWithValue(_StubTatoebaService([stubSentence, a2Sentence])),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(tatoebaExplorerProvider.notifier);
    await notifier.selectSentence(a2Sentence);

    final state = container.read(tatoebaExplorerProvider);
    expect(state.candidates.map((c) => c.term), ['water']);
  });

  test('addCandidateWordToDeck refuses a word outside the active level', () async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(testDb)],
    );
    addTearDown(container.dispose);

    const b1Candidate = ExtractedCandidateWord(
      term: 'feedback',
      frequencyScore: 4.3,
      estimatedLevel: CefrLevel.b1,
      isAlreadyInDb: true,
    );

    final notifier = container.read(tatoebaExplorerProvider.notifier);
    final countBefore = (await container.read(wordRepositoryProvider).getAllWords()).length;
    final added = await notifier.addCandidateWordToDeck(
      candidate: b1Candidate,
      sentence: stubSentence,
      customTranslation: 'retour',
    );

    expect(added, isFalse);
    final words = await container.read(wordRepositoryProvider).getAllWords();
    expect(words, hasLength(countBefore));
  });

  test('addCandidateWordToDeck accepts a word from the active level', () async {
    final container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(testDb)],
    );
    addTearDown(container.dispose);

    const a1Candidate = ExtractedCandidateWord(
      term: 'milk',
      frequencyScore: 5.5,
      estimatedLevel: CefrLevel.a1,
      isAlreadyInDb: false,
    );

    final notifier = container.read(tatoebaExplorerProvider.notifier);
    final added = await notifier.addCandidateWordToDeck(
      candidate: a1Candidate,
      sentence: stubSentence,
      customTranslation: 'lait',
    );

    expect(added, isTrue);
    final words = await container.read(wordRepositoryProvider).getAllWords();
    final milk = words.where((w) => w.term == 'milk').toList();
    expect(milk, hasLength(1));
    expect(milk.first.level, 'A1');
    expect(container.read(tatoebaExplorerProvider).addedTerms, contains('milk'));
  });

  testWidgets('Tatoeba explorer only displays candidates from the active level',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
          tatoebaServiceProvider
              .overrideWithValue(_StubTatoebaService([stubSentence])),
        ],
        child: MaterialApp(
          theme: bauhausTheme(),
          home: const TatoebaExplorerScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('water'), findsOneWidget);
    expect(find.text('station'), findsNothing);
    expect(find.text('feedback'), findsNothing);
    expect(find.text('1 mot(s)'), findsOneWidget);
  });
}
