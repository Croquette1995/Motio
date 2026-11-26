import 'package:drift/drift.dart';

/// Snapshot de couverture du barème CECRL : mots en base par rapport au quota
/// du niveau, persisté par langue apprise. Une ligne par (langue, niveau).
@DataClassName('LevelCoverageEntry')
class LevelCoverageTable extends Table {
  TextColumn get language => text().withLength(min: 2, max: 10)();
  TextColumn get level => text().withLength(min: 2, max: 10)(); // 'A1', 'A2', 'B1', 'B2'
  IntColumn get wordCount => integer()();
  IntColumn get quota => integer()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {language, level};
}
