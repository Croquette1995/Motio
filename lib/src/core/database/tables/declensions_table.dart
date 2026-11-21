import 'package:drift/drift.dart';
import 'languages_table.dart';

@DataClassName('DeclensionEntry')
class DeclensionsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get langId => integer().references(LanguagesTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get lemma => text().withLength(min: 1, max: 150)();
  TextColumn get pos => text().withLength(min: 3, max: 10)(); // NOUN, ADJ, DET
  TextColumn get gender => text().nullable()();
  TextColumn get declensionClass => text().nullable()();
  BoolColumn get isIrregular => boolean().withDefault(const Constant(false))();
  BoolColumn get isInvariable => boolean().withDefault(const Constant(false))();
  TextColumn get generalNoteJson => text().withDefault(const Constant('{}'))();
  TextColumn get formsJson => text().withDefault(const Constant('[]'))();
  TextColumn get source => text().withDefault(const Constant('manual'))();
  BoolColumn get isPublished => boolean().withDefault(const Constant(false))();

  @override
  List<Set<Column>> get uniqueKeys => [
        {langId, lemma, pos},
      ];
}
