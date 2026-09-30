import 'package:drift/drift.dart';
import 'words_table.dart';

@DataClassName('WordProgressEntry')
class WordProgressTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wordId => integer().unique().references(WordsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text().withLength(min: 1, max: 20)(); // 'new', 'learning', 'review', 'mastered'
  IntColumn get step => integer().withDefault(const Constant(0))();
  RealColumn get easeFactor => real().withDefault(const Constant(2.5))();
  IntColumn get intervalDays => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastReviewedAt => dateTime().nullable()();
  DateTimeColumn get nextReviewAt => dateTime().nullable()();
  IntColumn get consecutiveSuccesses => integer().withDefault(const Constant(0))();
}
