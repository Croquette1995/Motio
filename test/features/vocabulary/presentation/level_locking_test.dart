import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/core/database/app_database.dart';
import 'package:lexiflow/src/core/database/database_providers.dart';
import 'package:lexiflow/src/core/theme/bauhaus_theme.dart';
import 'package:lexiflow/src/features/settings/application/level_unlock_controller.dart';
import 'package:lexiflow/src/features/settings/application/user_level_controller.dart';
import 'package:lexiflow/src/features/settings/domain/cefr_level.dart';
import 'package:lexiflow/src/features/vocabulary/presentation/level_domains_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FixedLevelNotifier extends UserLevelNotifier {
  _FixedLevelNotifier(this.level);

  final CefrLevel level;

  @override
  CefrLevel build() => level;
}

void main() {
  testWidgets('A1 user: higher level tabs show lock icon and open unlock dialog',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();
    addTearDown(testDb.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(testDb)],
        child: MaterialApp(
          theme: bauhausTheme(),
          home: const LevelDomainsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // A1 content is shown, no lock on the active level
    final lockIcons = find.byIcon(Icons.lock);
    expect(lockIcons, findsNWidgets(3));

    // Tapping the locked A2 tab opens the unlock dialog with the criterion
    await tester.tap(find.text('A2').first);
    await tester.pumpAndSettle();

    expect(find.text('Niveau A2 verrouillé'), findsOneWidget);
    expect(find.textContaining('Maîtrisez 70 % du corpus A1'), findsOneWidget);
    expect(find.textContaining('0/14'), findsNWidgets(2));
    expect(find.text('Je suis certain de mon niveau'), findsOneWidget);

    // Content stays on A1
    expect(find.textContaining('NIVEAU A1'), findsOneWidget);
  });

  testWidgets('Manual unlock is persisted and unlocks the level content',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();
    addTearDown(testDb.close);

    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(testDb)],
        child: MaterialApp(
          theme: bauhausTheme(),
          home: Consumer(
            builder: (context, ref, _) {
              container = ProviderScope.containerOf(context);
              return const LevelDomainsScreen();
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('A2').first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Je suis certain de mon niveau'));
    await tester.pumpAndSettle();

    expect(find.text('Débloquer le A2 immédiatement ?'), findsOneWidget);
    await tester.tap(find.text('Débloquer le A2'));
    await tester.pumpAndSettle();

    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getStringList(LevelUnlockService.prefsKey), contains('A2'));

    final state = container.read(levelUnlockStateProvider).valueOrNull;
    expect(state, isNotNull);
    expect(state!.isUnlocked(CefrLevel.a2), isTrue);

    // The A2 tab is now selectable and displays its content
    await tester.tap(find.text('A2').first);
    await tester.pumpAndSettle();
    expect(find.textContaining('NIVEAU A2'), findsOneWidget);
  });

  testWidgets('Lower levels stay browsable with a review badge',
      (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final testDb = AppDatabase(NativeDatabase.memory());
    await testDb.seedInitialData();
    addTearDown(testDb.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(testDb),
          userLevelProvider.overrideWith(() => _FixedLevelNotifier(CefrLevel.a2)),
        ],
        child: MaterialApp(
          theme: bauhausTheme(),
          home: const LevelDomainsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Tap on the lower level tab A1
    await tester.tap(find.text('A1').first);
    await tester.pumpAndSettle();

    expect(find.text('RÉVISION A1'), findsOneWidget);
    expect(find.textContaining('Basics & Greetings'), findsOneWidget);
  });
}
