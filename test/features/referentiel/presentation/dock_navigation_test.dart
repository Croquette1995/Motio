import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/app.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/core/widgets/bauhaus_dock_shell.dart';

void main() {
  testWidgets('Dock displays 4 tabs, navigates to Référentiel, and toggles Déclinaisons by language', (tester) async {
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

    expect(find.byType(MainShellScreen), findsOneWidget);
    expect(find.text('ACCUEIL'), findsOneWidget);
    expect(find.text('VOCABULAIRE'), findsOneWidget);
    expect(find.text('RÉFÉRENTIEL'), findsOneWidget);
    expect(find.text('DOMAINES'), findsOneWidget);

    // Tap Référentiel dock tab
    await tester.tap(find.text('RÉFÉRENTIEL'));
    await tester.pumpAndSettle();

    // Default active language is 'fr' (has_declensions == false -> DÉCLINAISONS hidden)
    expect(find.text('LEÇONS'), findsOneWidget);
    expect(find.text('CONJUGAISONS'), findsOneWidget);
    expect(find.text('DÉCLINAISONS'), findsNothing);

    // Switch to 'de' -> DÉCLINAISONS appears
    await tester.tap(find.text('DE · Allemand'));
    await tester.pumpAndSettle();
    expect(find.text('DÉCLINAISONS'), findsOneWidget);

    // Open German lesson & check content
    expect(find.textContaining('Nominatif et Accusatif'), findsOneWidget);
    await tester.tap(find.textContaining('Nominatif et Accusatif'));
    await tester.pumpAndSettle();
    expect(find.text("S'ENTRAÎNER"), findsOneWidget);

    await testDb.close();
  });
}
