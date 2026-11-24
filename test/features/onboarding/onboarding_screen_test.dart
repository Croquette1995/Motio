import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lexiflow/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:lexiflow/src/features/settings/application/user_level_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  GoRouter testRouter(ProviderContainer container) => GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(
            path: '/',
            builder: (_, __) => const OnboardingScreen(),
          ),
          GoRoute(
            path: '/home',
            builder: (_, __) =>
                const Scaffold(body: Center(child: Text('dashboard'))),
          ),
        ],
        redirect: (context, state) {
          final onboarded =
              container.read(isLevelOnboardedProvider).valueOrNull;
          if (onboarded == true && state.matchedLocation == '/') {
            return '/home';
          }
          return null;
        },
      );

  group('OnboardingScreen Tests', () {
    void useTallViewport(WidgetTester tester) {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(800, 1400);
      addTearDown(tester.view.reset);
    }
    testWidgets('shows language choice, level choice and A1 preselected', (
      tester,
    ) async {
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OnboardingScreen())),
      );

      expect(find.text('Bienvenue dans Motio'), findsOneWidget);
      expect(find.text('Anglais'), findsOneWidget);
      expect(find.text('Autre langue · bientôt disponible'), findsOneWidget);
      expect(find.text('Niveau A1 · Débutant'), findsOneWidget);
      expect(find.text('Niveau B2 · Avancé'), findsOneWidget);
      expect(
        find.textContaining('Tu apprends l\'anglais · niveau A1'),
        findsOneWidget,
      );
    });

    testWidgets('summary updates when level selection changes', (
      tester,
    ) async {
      useTallViewport(tester);
      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OnboardingScreen())),
      );

      await tester.tap(find.text('Niveau B2 · Avancé'));
      await tester.pump();

      expect(
        find.textContaining('Tu apprends l\'anglais · niveau B2'),
        findsOneWidget,
      );
    });

    testWidgets('COMMENCER persists language and level then leaves', (
      tester,
    ) async {
      useTallViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final router = testRouter(container);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Niveau A2 · Élémentaire'));
      await tester.pump();
      await tester.tap(find.text('COMMENCER'));
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_cefr_level'), equals('A2'));
      expect(prefs.getBool('user_level_onboarded'), isTrue);
      expect(prefs.getString('tts_lang'), equals('en'));
      expect(find.text('Bienvenue dans Motio'), findsNothing);
      expect(find.text('dashboard'), findsOneWidget);
    });

    testWidgets('JE NE SAIS PAS skips with default A1 and marks onboarded', (
      tester,
    ) async {
      useTallViewport(tester);
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final router = testRouter(container);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp.router(routerConfig: router),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('JE NE SAIS PAS'));
      await tester.pumpAndSettle();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('user_cefr_level'), equals('A1'));
      expect(prefs.getBool('user_level_onboarded'), isTrue);
      expect(find.text('Bienvenue dans Motio'), findsNothing);
      expect(find.text('dashboard'), findsOneWidget);
    });
  });
}
