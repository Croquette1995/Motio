import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import '../../features/vocabulary/data/drift_word_repository.dart';
import '../../features/vocabulary/domain/i_word_repository.dart';
import '../../features/learning_engine/data/drift_progress_repository.dart';
import '../../features/learning_engine/application/session_scheduler_service.dart';
import '../../features/learning_engine/application/srs_service.dart';
import '../../features/referentiel/data/drift_referentiel_repository.dart';
import '../../features/referentiel/application/referentiel_import_service.dart';
import '../../features/referentiel/application/vocabulary_bridge_service.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final wordRepositoryProvider = Provider<IWordRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftWordRepository(db);
});

final progressRepositoryProvider = Provider<DriftProgressRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftProgressRepository(db);
});

final sessionSchedulerServiceProvider = Provider<SessionSchedulerService>((ref) {
  final wordRepo = ref.watch(wordRepositoryProvider);
  final progressRepo = ref.watch(progressRepositoryProvider);
  return SessionSchedulerService(
    wordRepository: wordRepo,
    progressRepository: progressRepo,
  );
});

final srsServiceProvider = Provider<SrsService>((ref) {
  final progressRepo = ref.watch(progressRepositoryProvider);
  return SrsService(progressRepo);
});

final referentielRepositoryProvider = Provider<DriftReferentielRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftReferentielRepository(db);
});

final referentielImportServiceProvider = Provider<ReferentielImportService>((ref) {
  final repo = ref.watch(referentielRepositoryProvider);
  return ReferentielImportService(repo);
});

final vocabularyBridgeServiceProvider = Provider<VocabularyBridgeService>((ref) {
  final refRepo = ref.watch(referentielRepositoryProvider);
  final wordRepo = ref.watch(wordRepositoryProvider);
  return VocabularyBridgeService(
    referentielRepo: refRepo,
    wordRepo: wordRepo,
  );
});
