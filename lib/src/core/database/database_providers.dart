import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_database.dart';
import '../../features/vocabulary/data/drift_word_repository.dart';
import '../../features/vocabulary/domain/i_word_repository.dart';
import '../../features/learning_engine/data/drift_progress_repository.dart';
import '../../features/learning_engine/application/session_scheduler_service.dart';
import '../../features/learning_engine/application/srs_service.dart';

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
