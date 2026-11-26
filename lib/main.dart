import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';
import 'src/core/database/database_providers.dart';
import 'src/features/vocabulary/presentation/vocab_enrichment_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final db = container.read(appDatabaseProvider);
  await db.seedInitialData();

  // Déclencheurs du pré-remplissage d'enrichissement (onboarding, changement
  // de niveau, reprise après interruption).
  container.read(vocabEnrichmentAutoTriggerProvider);

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LexiFlowApp(),
    ),
  );
}
