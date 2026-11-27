import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/core/theme/bauhaus_theme.dart';
import 'package:lexiflow/src/features/vocabulary/application/vocab_enrichment_service.dart';
import 'package:lexiflow/src/features/vocabulary/data/tatoeba_service.dart';
import 'package:lexiflow/src/features/vocabulary/domain/tatoeba_sentence.dart';
import 'package:lexiflow/src/features/vocabulary/presentation/vocab_enrichment_controller.dart';
import 'package:lexiflow/src/features/vocabulary/presentation/vocab_enrichment_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _ScriptedTatoebaService extends TatoebaService {
  _ScriptedTatoebaService(this.fetchScript);

  final Future<List<TatoebaSentence>> Function() fetchScript;

  @override
  Future<List<TatoebaSentence>> searchSentences({
    String from = 'eng',
    String to = 'fra',
    String query = '',
    bool random = true,
    int pageSize = 5,
    int wordCountMin = 3,
    int wordCountMax = 12,
  }) =>
      fetchScript();
}

void main() {
  late AppDatabase testDb;

  setUp(() async {
    SharedPreferences.setMockInitialValues({
      'user_level_onboarded': true,
      'user_cefr_level': 'A1',
    });
    testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();
  });

  tearDown(() async {
    await testDb.close();
  });

  TatoebaSentence sentenceOf(String textEn, int id) =>
      TatoebaSentence(id: id, textEn: textEn, textFr: 'traduction $textEn');

  Widget harness({
    required AppDatabase db,
    required TatoebaService tatoeba,
    required Widget child,
  }) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        tatoebaServiceProvider.overrideWithValue(tatoeba),
        vocabEnrichmentServiceProvider.overrideWith((ref) {
          return VocabEnrichmentService(
            wordRepository: ref.watch(wordRepositoryProvider),
            tatoebaService: tatoeba,
            translationResolver: (term) async => 'trad-$term',
          );
        }),
      ],
      child: MaterialApp(theme: bauhausTheme(), home: child),
    );
  }

  testWidgets('idle state exposes the active level and the 1-click button',
      (tester) async {
    await tester.pumpWidget(harness(
      db: testDb,
      tatoeba: _ScriptedTatoebaService(() async => []),
      child: const VocabEnrichmentScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.text('ENRICHIR MON NIVEAU A1'), findsOneWidget);
    expect(find.text('Couverture du A1 : 20 / 500 mots'), findsOneWidget);
    expect(find.text('ENRICHIR MON NIVEAU'), findsOneWidget);
  });

  testWidgets('running state shows live progress and cancellation',
      (tester) async {
    final gates = <Completer<List<TatoebaSentence>>>[];
    var callIndex = 0;
    final tatoeba = _ScriptedTatoebaService(() {
      final completer = Completer<List<TatoebaSentence>>();
      gates.add(completer);
      callIndex++;
      if (callIndex == 1) {
        completer.complete([sentenceOf('the dog likes station', 1)]);
      }
      return completer.future;
    });

    await tester.pumpWidget(harness(
      db: testDb,
      tatoeba: tatoeba,
      child: const VocabEnrichmentScreen(),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ENRICHIR MON NIVEAU'));
    await tester.pumpAndSettle();
    expect(find.textContaining('ENRICHISSEMENT DU A1'), findsOneWidget);
    expect(find.textContaining('21 / 500 mots ajoutés'), findsOneWidget);

    await tester.tap(find.text('ANNULER'));
    await tester.pump();
    completerRelease(gates, [sentenceOf('station office', 3)]);
    await tester.pumpAndSettle();

    expect(find.text('ENRICHISSEMENT INTERROMPU'), findsOneWidget);
    expect(find.textContaining('1 mots ajoutés au A1'), findsOneWidget);
  });

  testWidgets('network failure surfaces a retry', (tester) async {
    final tatoeba = _ScriptedTatoebaService(() async => []);

    await tester.pumpWidget(harness(
      db: testDb,
      tatoeba: tatoeba,
      child: const VocabEnrichmentScreen(),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('ENRICHIR MON NIVEAU'));
    await tester.pumpAndSettle();

    expect(find.text('ENRICHISSEMENT SUSPENDU'), findsOneWidget);
    expect(find.textContaining('Impossible de joindre Tatoeba'), findsOneWidget);
    expect(find.text('RÉESSAYER'), findsOneWidget);
  });

  testWidgets('quota already reached is detected as done without any fetch',
      (tester) async {
    for (var i = 0; i < 479; i++) {
      await testDb.into(testDb.wordsTable).insert(WordsTableCompanion.insert(
            term: 'zzfill$i',
            translation: '$i',
            contextSentence: 'filler $i',
            category: 'Daily Life & Home',
            level: 'A1',
          ));
    }

    var fetchCalls = 0;
    final tatoeba = _ScriptedTatoebaService(() {
      fetchCalls++;
      return fetchCalls == 1
          ? Future.value([sentenceOf('the dog likes station', 9)])
          : Future.value([]);
    });

    await tester.pumpWidget(harness(
      db: testDb,
      tatoeba: tatoeba,
      child: const VocabEnrichmentScreen(),
    ));
    await tester.pumpAndSettle();

    expect(find.textContaining('Couverture du A1 : 499 / 500'), findsOneWidget);

    await tester.tap(find.text('ENRICHIR MON NIVEAU'));
    await tester.pumpAndSettle();

    expect(fetchCalls, 1,
        reason: 'le niveau A1 n\'a plus qu\'un mot manquant : 1 page suffit');
    expect(find.text('ENRICHISSEMENT TERMINÉ'), findsOneWidget);
    expect(find.textContaining('1 mots ajoutés au A1'), findsOneWidget);
  });
}

void completerRelease(
  List<Completer<List<TatoebaSentence>>> gates,
  List<TatoebaSentence> sentences,
) {
  for (final gate in gates) {
    if (!gate.isCompleted) {
      gate.complete(sentences);
      return;
    }
  }
}
