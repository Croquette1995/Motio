import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/native.dart';
import 'package:lexiflow/src/app.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';

void main() {
  testWidgets('LexiFlow app loads dashboard smoke test', (WidgetTester tester) async {
    final testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
        ],
        child: const LexiFlowApp(),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Motio'), findsOneWidget);
    expect(find.text('NIVEAU ACTUEL'), findsOneWidget);
    expect(find.text('Niveau A1 · Débutant'), findsOneWidget);

    await testDb.close();
  });
}
