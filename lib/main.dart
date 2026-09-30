import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'src/app.dart';
import 'src/core/database/database_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final container = ProviderContainer();
  final db = container.read(appDatabaseProvider);
  await db.seedInitialData();

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const LexiFlowApp(),
    ),
  );
}
