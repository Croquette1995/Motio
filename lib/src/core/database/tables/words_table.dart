import 'package:drift/drift.dart';

@DataClassName('WordEntry')
class WordsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get term => text().withLength(min: 1, max: 100)();
  TextColumn get translation => text().withLength(min: 1, max: 200)();
  TextColumn get contextSentence => text()();
  TextColumn get category => text().withLength(min: 1, max: 100)();
  TextColumn get level => text().withLength(min: 2, max: 10)(); // 'A1', 'A2', 'B1', 'B2'
  TextColumn get language => text().withLength(min: 2, max: 10).withDefault(const Constant('en'))();
  TextColumn get targetLanguage => text().withLength(min: 2, max: 10).withDefault(const Constant('fr'))();
  TextColumn get pos => text().withLength(min: 1, max: 30).withDefault(const Constant('noun'))();
  RealColumn get frequencyScore => real().withDefault(const Constant(4.0))();
  TextColumn get lemma => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
