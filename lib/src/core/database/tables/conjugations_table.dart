import 'package:drift/drift.dart';
import 'languages_table.dart';

@DataClassName('ConjugationEntry')
class ConjugationsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get langId => integer().references(LanguagesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get lemma => text().withLength(min: 1, max: 150)();
  TextColumn get verbGroup => text().nullable()();
  TextColumn get auxiliariesJson => text().withDefault(const Constant('[]'))();
  BoolColumn get isPronominal => boolean().withDefault(const Constant(false))();
  TextColumn get reflexiveCase => text().nullable()();
  BoolColumn get isIrregular => boolean().withDefault(const Constant(false))();
  BoolColumn get isDefective => boolean().withDefault(const Constant(false))();
  TextColumn get generalNoteJson => text().withDefault(const Constant('{}'))();
  TextColumn get formsJson => text().withDefault(const Constant('[]'))();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {langId, lemma},
      ];
}
