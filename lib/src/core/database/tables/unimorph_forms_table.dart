import 'package:drift/drift.dart';
import 'words_table.dart';

@DataClassName('UnimorphFormEntry')
class UnimorphFormsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get wordId => integer().references(WordsTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get form => text().withLength(min: 1, max: 150)(); // 'spoke', 'written', 'children'
  TextColumn get unimorphTag => text().withLength(min: 1, max: 100)(); // 'V;PST', 'V;V.PTCP;PST', 'N;PL'
  TextColumn get labelFr => text().withLength(min: 1, max: 150)(); // 'Prétérit / Passé', 'Participe passé', 'Pluriel'
  BoolColumn get isIrregular => boolean().withDefault(const Constant(false))();
}
