import 'package:drift/drift.dart';

@DataClassName('WordEntry')
class WordsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get term => text().withLength(min: 1, max: 100)();
  TextColumn get translation => text().withLength(min: 1, max: 200)();
  TextColumn get contextSentence => text()();
  TextColumn get category => text().withLength(min: 1, max: 100)();
  TextColumn get level => text().withLength(min: 2, max: 10)(); // 'B1' or 'B2'
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
