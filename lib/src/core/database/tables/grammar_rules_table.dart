import 'package:drift/drift.dart';

@DataClassName('GrammarRuleEntry')
class GrammarRulesTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get language => text().withLength(min: 2, max: 10).withDefault(const Constant('en'))();
  TextColumn get ruleCode => text().withLength(min: 1, max: 50)(); // 'PAST_SIMPLE', 'PRESENT_PERFECT'
  TextColumn get title => text().withLength(min: 1, max: 150)(); // 'Le Passé Simple (Prétérit)'
  TextColumn get level => text().withLength(min: 2, max: 10)(); // 'A2', 'B1'
  TextColumn get explanationFr => text()();
  TextColumn get formulaPattern => text()(); // 'Sujet + V;PST (verbes réguliers: -ed)'
}
