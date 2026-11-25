import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/onboarding/presentation/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  group("PlacementQuizCard (intégré à l'onboarding)", () {
    Future<void> openQuiz(WidgetTester tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = const Size(800, 2400);
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const ProviderScope(child: MaterialApp(home: OnboardingScreen())),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('JE NE SAIS PAS'));
      await tester.pumpAndSettle();
    }

    testWidgets(
        "le bloc A1 est présenté en premier, mots les plus courants d'abord",
        (tester) async {
      await openQuiz(tester);

      expect(find.text('TEST DE POSITIONNEMENT'), findsOneWidget);
      expect(find.text('Niveau A1 · mot 1/10'), findsOneWidget);
      expect(find.text('hello'), findsOneWidget);
    });

    testWidgets(
        "le quiz s'arrête après un niveau non reconnu et recommande le dernier niveau maîtrisé",
        (tester) async {
      await openQuiz(tester);

      for (var i = 0; i < 10; i++) {
        await tester.tap(find.text('JE CONNAIS'));
        await tester.pump();
      }
      expect(find.text('Niveau A2 · mot 1/10'), findsOneWidget);

      for (var i = 0; i < 10; i++) {
        await tester.tap(find.text('JE NE CONNAIS PAS'));
        await tester.pump();
      }

      expect(find.text('NIVEAU RECOMMANDÉ'), findsOneWidget);
      expect(find.text('A1'), findsOneWidget);
    });

    testWidgets(
        "UTILISER CE NIVEAU pré-sélectionne le niveau recommandé dans l'onboarding",
        (tester) async {
      await openQuiz(tester);

      for (var i = 0; i < 10; i++) {
        await tester.tap(find.text('JE CONNAIS'));
        await tester.pump();
      }
      for (var i = 0; i < 10; i++) {
        await tester.tap(find.text('JE CONNAIS'));
        await tester.pump();
      }
      for (var i = 0; i < 10; i++) {
        await tester.tap(find.text('JE NE CONNAIS PAS'));
        await tester.pump();
      }
      expect(find.text('NIVEAU RECOMMANDÉ'), findsOneWidget);
      expect(find.text('A2'), findsOneWidget);

      await tester.tap(find.text('CHOISIR UN AUTRE NIVEAU'));
      await tester.pumpAndSettle();

      expect(find.text('TEST DE POSITIONNEMENT'), findsNothing);
      expect(find.textContaining('niveau recommandé : A2'), findsOneWidget);
      expect(
        find.textContaining("Tu apprends l'anglais · niveau A2"),
        findsOneWidget,
      );
    });
  });
}
