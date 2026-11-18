import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lexiflow/src/features/vocabulary/data/wiktionary_provider.dart';
import 'package:lexiflow/src/features/vocabulary/domain/word_details.dart';
import 'package:lexiflow/src/features/vocabulary/presentation/wiktionary_enrichment_widget.dart';

void main() {
  testWidgets('WiktionaryEnrichmentWidget renders closed tile initially and expands to show content', (tester) async {
    const testDetails = WordDetails(
      term: 'resilient',
      definitions: [
        WordDefinition(
          partOfSpeech: 'Adjective',
          text: 'Returning quickly to original shape',
          example: 'A resilient material',
        ),
      ],
      etymology: 'From Latin resiliens',
      synonyms: ['flexible', 'strong'],
      translations: [
        WordTranslation(language: 'Français', term: 'résilient'),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wordDetailsProvider('resilient').overrideWith(
            (ref) => Future.value(testDetails),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WiktionaryEnrichmentWidget(term: 'resilient'),
            ),
          ),
        ),
      ),
    );

    // Should display tile title
    expect(find.text('Définitions et détails'), findsOneWidget);
    expect(find.text('Définitions :'), findsNothing);

    // Tap to expand tile
    await tester.tap(find.text('Définitions et détails'));
    await tester.pumpAndSettle();

    // Now expanded details should be visible
    expect(find.text('Définitions :'), findsOneWidget);
    expect(find.text('Adjective'), findsOneWidget);
    expect(find.text('Returning quickly to original shape'), findsOneWidget);
    expect(find.text('Ex. "A resilient material"'), findsOneWidget);
    expect(find.text('Synonymes :'), findsOneWidget);
    expect(find.text('flexible'), findsOneWidget);
    expect(find.text('strong'), findsOneWidget);
    expect(find.text('Traductions :'), findsOneWidget);
    expect(find.text('Français: résilient'), findsOneWidget);
    expect(find.text('Étymologie : From Latin resiliens'), findsOneWidget);
  });

  testWidgets('WiktionaryEnrichmentWidget displays discrete message when 404 / empty details returned', (tester) async {
    const emptyDetails = WordDetails(term: 'nonexistent');

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          wordDetailsProvider('nonexistent').overrideWith(
            (ref) => Future.value(emptyDetails),
          ),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: WiktionaryEnrichmentWidget(term: 'nonexistent'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Définitions et détails'));
    await tester.pumpAndSettle();

    expect(
      find.text('Aucune donnée complémentaire disponible sur Wiktionnaire.'),
      findsOneWidget,
    );
  });
}
