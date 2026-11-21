import 'package:drift/drift.dart';
import 'grammar_lessons_table.dart';

@DataClassName('LessonProgressEntry')
class LessonProgressTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get userKey => text().withDefault(const Constant('local'))();
  IntColumn get lessonId =>
      integer().references(GrammarLessonsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get exerciseResultsJson => text().withDefault(const Constant('{}'))();
  RealColumn get score => real().withDefault(const Constant(0.0))();
  DateTimeColumn get lastSeenAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get nextDueAt => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {userKey, lessonId},
      ];
}
