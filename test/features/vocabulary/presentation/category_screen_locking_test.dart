import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/core/theme/bauhaus_theme.dart';
import 'package:lexiflow/src/features/settings/application/user_level_controller.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/presentation/category_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FixedLevelNotifier extends UserLevelNotifier {
  _FixedLevelNotifier(this.level);

  final CefrLevel level;

  @override
  CefrLevel build() => level;
}

Future<void> pumpCategoryScreen(
  WidgetTester tester, {
  required AppDatabase testDb,
  CefrLevel userLevel = CefrLevel.a1,
}) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(testDb),
        if (userLevel != CefrLevel.a1)
          userLevelProvider.overrideWith(() => _FixedLevelNotifier(userLevel)),
      ],
      child: MaterialApp(
        theme: bauhausTheme(),
        home: const CategoryScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  late AppDatabase testDb;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();
  });

  tearDown(() async {
    await testDb.close();
  });

  testWidgets('Catalogue defaults to the user level and locks higher levels',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpCategoryScreen(tester, testDb: testDb);

    // No more "TOUS NIVEAUX" escape hatch
    expect(find.text('TOUS NIVEAUX'), findsNothing);

    // A1 chip active by default, locked levels carry a lock icon
    expect(find.text('NIVEAU A1'), findsOneWidget);
    final lockAvatars = find.byIcon(Icons.lock);
    expect(lockAvatars, findsNWidgets(3));

    // Only A1 words are listed by default
    expect(find.text('hello'), findsOneWidget);
    expect(find.text('analyze'), findsNothing);
    expect(find.text('station'), findsNothing);

    // Tapping a locked chip opens the unlock dialog instead of filtering
    await tester.tap(find.text('NIVEAU B1'));
    await tester.pumpAndSettle();
    expect(find.text('Niveau B1 verrouillé'), findsOneWidget);
  });

  testWidgets('Lower levels are browsable as review', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpCategoryScreen(tester, testDb: testDb, userLevel: CefrLevel.a2);

    expect(find.text('NIVEAU A2'), findsOneWidget);
    expect(find.text('RÉVISION A1'), findsOneWidget);

    await tester.tap(find.text('RÉVISION A1'));
    await tester.pumpAndSettle();

    expect(find.text('hello'), findsOneWidget);
    expect(find.text('station'), findsNothing);
  });

  testWidgets('Unlocked review level filter shows A2 catalogue content',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await pumpCategoryScreen(tester, testDb: testDb, userLevel: CefrLevel.a2);

    await tester.tap(find.text('NIVEAU A2'));
    await tester.pumpAndSettle();

    expect(find.text('station'), findsOneWidget);
  });
}
