import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/features/settings/application/user_level_controller.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/application/vocab_enrichment_service.dart';
import 'package:lexiflow/src/features/vocabulary/data/tatoeba_service.dart';
import 'package:lexiflow/src/features/vocabulary/domain/tatoeba_sentence.dart';
import 'package:lexiflow/src/features/vocabulary/presentation/vocab_enrichment_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _HangingTatoebaService extends TatoebaService {
  final Completer<List<TatoebaSentence>> gate = Completer();

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
      gate.future;
}

void main() {
  late AppDatabase testDb;

  setUp(() async {
    SharedPreferences.setMockInitialValues({'user_level_onboarded': false});
    testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();
  });

  tearDown(() async {
    await testDb.close();
  });

  ProviderContainer makeContainer(TatoebaService tatoeba) {
    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(testDb),
        tatoebaServiceProvider.overrideWithValue(tatoeba),
        vocabEnrichmentServiceProvider.overrideWith((ref) {
          return VocabEnrichmentService(
            wordRepository: ref.watch(wordRepositoryProvider),
            tatoebaService: tatoeba,
            translationResolver: (term) async => 'trad-$term',
          );
        }),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  test('returns silently before onboarding is completed', () async {
    final tatoeba = _HangingTatoebaService();
    final container = makeContainer(tatoeba);

    await container.read(isLevelOnboardedProvider.future);
    container.read(vocabEnrichmentAutoTriggerProvider);

    container.read(userLevelProvider.notifier).setLevel(CefrLevel.a2);

    final state = container.read(vocabEnrichmentProvider);
    expect(state.phase, VocabEnrichmentPhase.idle);
  });

  test('restarts automatically when the active level changes once onboarded',
      () async {
    final tatoeba = _HangingTatoebaService();
    final container = makeContainer(tatoeba);

    await container.read(isLevelOnboardedProvider.future);
    container.read(vocabEnrichmentAutoTriggerProvider);

    await container.read(userLevelProvider.notifier).setLevel(CefrLevel.a2);
    container.invalidate(isLevelOnboardedProvider);
    await container.read(isLevelOnboardedProvider.future);

    await container.read(userLevelProvider.notifier).setLevel(CefrLevel.b1);

    final state = container.read(vocabEnrichmentProvider);
    expect(state.phase, VocabEnrichmentPhase.running);
    expect(state.level, CefrLevel.b1);
  });
}
