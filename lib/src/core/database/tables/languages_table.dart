import 'package:drift/drift.dart';

@DataClassName('LanguageEntry')
class LanguagesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().withLength(min: 2, max: 10).unique()();
  TextColumn get nameL10nJson => text()();
  BoolColumn get isNonLatin => boolean().withDefault(const Constant(false))();
  TextColumn get grammarProfileJson => text()();
}
