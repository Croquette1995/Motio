import 'package:drift/drift.dart';
import 'languages_table.dart';

@DataClassName('GrammarLessonEntry')
class GrammarLessonsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get langId => integer().references(LanguagesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get slug => text().withLength(min: 1, max: 150)();
  TextColumn get level => text().withLength(min: 2, max: 4)();
  IntColumn get orderIndex => integer().withDefault(const Constant(1))();
  TextColumn get titleJson => text().withDefault(const Constant('{}'))();
  TextColumn get prerequisiteIdsJson => text().withDefault(const Constant('[]'))();
  TextColumn get linkedVerbIdsJson => text().withDefault(const Constant('[]'))();
  TextColumn get targetTensesJson => text().withDefault(const Constant('[]'))();
  TextColumn get linkedDeclensionIdsJson => text().withDefault(const Constant('[]'))();
  TextColumn get targetCasesJson => text().withDefault(const Constant('[]'))();
  TextColumn get blocksJson => text().withDefault(const Constant('[]'))();
  TextColumn get exercisesJson => text().withDefault(const Constant('[]'))();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {langId, slug},
      ];
}
