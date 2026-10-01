import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../domain/word_progress.dart';
import 'progress_mapper.dart';

class DriftProgressRepository {
  final AppDatabase db;

  DriftProgressRepository(this.db);

  Future<WordProgress?> getProgressByWordId(int wordId) async {
    final query = db.select(db.wordProgressTable)
      ..where((tbl) => tbl.wordId.equals(wordId));
    final entry = await query.getSingleOrNull();
    return entry?.toDomain();
  }

  Future<List<WordProgress>> getDueProgresses({DateTime? asOf, int limit = 20}) async {
    final reference = asOf ?? DateTime.now();
    final query = db.select(db.wordProgressTable)
      ..where((tbl) =>
          tbl.nextReviewAt.isNotNull() &
          tbl.nextReviewAt.isSmallerOrEqualValue(reference))
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.nextReviewAt)])
      ..limit(limit);

    final entries = await query.get();
    return entries.map((e) => e.toDomain()).toList();
  }

  Future<List<WordProgress>> getNewProgresses({int limit = 5}) async {
    final query = db.select(db.wordProgressTable)
      ..where((tbl) => (tbl.status.equals('new') | tbl.step.equals(0)) & tbl.lastReviewedAt.isNull())
      ..limit(limit);

    final entries = await query.get();
    return entries.map((e) => e.toDomain()).toList();
  }

  Future<void> saveProgress(WordProgress progress) async {
    final companion = progress.toCompanion();
    final existing = await getProgressByWordId(progress.wordId);
    if (existing != null && existing.id != null) {
      await (db.update(db.wordProgressTable)..where((tbl) => tbl.wordId.equals(progress.wordId)))
          .write(companion.copyWith(id: Value(existing.id!)));
    } else {
      await db.into(db.wordProgressTable).insertOnConflictUpdate(companion);
    }
  }
}
