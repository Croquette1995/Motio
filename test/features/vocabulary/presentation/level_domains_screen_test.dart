import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/core/theme/bauhaus_theme.dart';
import 'package:lexiflow/src/features/settings/application/user_level_controller.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/presentation/level_domains_screen.dart';

void main() {
  late AppDatabase testDb;

  setUp(() async {
    testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();
  });

  tearDown(() async {
    await testDb.close();
  });

  Widget buildTestableWidget({CefrLevel userLevel = CefrLevel.a1}) {
    return ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(testDb),
        if (userLevel != CefrLevel.a1)
          userLevelProvider.overrideWith(() => _FixedLevelNotifier(userLevel)),
      ],
      child: MaterialApp(
        theme: bauhausTheme(),
        home: const LevelDomainsScreen(),
      ),
    );
  }

  testWidgets('LevelDomainsScreen renders level tabs and A1 domains', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget());
    await tester.pumpAndSettle();

    // Verify AppBar
    expect(find.text('DOMAINES & PROGRESSION'), findsOneWidget);

    // Verify CEFR level buttons
    expect(find.text('A1'), findsWidgets);
    expect(find.text('A2'), findsWidgets);
    expect(find.text('B1'), findsWidgets);
    expect(find.text('B2'), findsWidgets);

    // Verify category titles for level A1
    expect(find.textContaining('Basics & Greetings'), findsOneWidget);
    expect(find.textContaining('Food & Drink'), findsOneWidget);
    expect(find.textContaining('Daily Life'), findsOneWidget);

    // Verify expansion of category
    await tester.tap(find.textContaining('Basics & Greetings'));
    await tester.pumpAndSettle();

    // Should display learning cards (hello, welcome...)
    expect(find.text('hello'), findsOneWidget);
    expect(find.text('bonjour'), findsOneWidget);
    expect(find.text('Autres exemples Tatoeba'), findsWidgets);
  });

  testWidgets('LevelDomainsScreen switches level to A2 on tap', (WidgetTester tester) async {
    await tester.pumpWidget(buildTestableWidget(userLevel: CefrLevel.a2));
    await tester.pumpAndSettle();

    // Tap on tab A2
    await tester.tap(find.text('A2').first);
    await tester.pumpAndSettle();

    // Verify A2 subtitle
    expect(find.textContaining('NIVEAU A2'), findsOneWidget);
  });
}

class _FixedLevelNotifier extends UserLevelNotifier {
  _FixedLevelNotifier(this.level);

  final CefrLevel level;

  @override
  CefrLevel build() => level;
}
