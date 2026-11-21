import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/widgets/bauhaus_dock_shell.dart';
import '../features/learning_engine/presentation/dashboard_screen.dart';
import '../features/learning_engine/presentation/session_screen.dart';
import '../features/practice_canvas/presentation/digital_ink_init_screen.dart';
import '../features/referentiel/domain/conjugation.dart';
import '../features/referentiel/domain/declension.dart';
import '../features/referentiel/domain/grammar_lesson.dart';
import '../features/referentiel/presentation/conjugation_detail_screen.dart';
import '../features/referentiel/presentation/declension_detail_screen.dart';
import '../features/referentiel/presentation/lesson_detail_screen.dart';
import '../features/referentiel/presentation/lesson_practice_screen.dart';
import '../features/referentiel/presentation/referentiel_screen.dart';
import '../features/referentiel/presentation/studio/bundle_import_export_screen.dart';
import '../features/referentiel/presentation/studio/conjugation_editor_screen.dart';
import '../features/referentiel/presentation/studio/declension_editor_screen.dart';
import '../features/referentiel/presentation/studio/lesson_editor_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/vocabulary/presentation/category_screen.dart';
import '../features/vocabulary/presentation/level_domains_screen.dart';
import '../features/vocabulary/presentation/tatoeba_explorer_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/init',
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScreen(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                name: 'dashboard',
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/vocabulary',
                name: 'vocabulary',
                builder: (context, state) => const CategoryScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/referentiel',
                name: 'referentiel',
                builder: (context, state) => const ReferentielScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/domains',
                name: 'domains',
                builder: (context, state) => const LevelDomainsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/init',
        name: 'init',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const DigitalInkInitScreen(),
      ),
      GoRoute(
        path: '/tatoeba',
        name: 'tatoeba',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const TatoebaExplorerScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/session',
        name: 'session',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SessionScreen(),
      ),
      GoRoute(
        path: '/referentiel/lesson/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final preview = state.extra is GrammarLessonRecord
              ? state.extra as GrammarLessonRecord
              : null;
          return LessonDetailScreen(lessonId: id, previewLesson: preview);
        },
      ),
      GoRoute(
        path: '/referentiel/lesson/:id/practice',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final preview = state.extra is GrammarLessonRecord
              ? state.extra as GrammarLessonRecord
              : null;
          return LessonPracticeScreen(lessonId: id, previewLesson: preview);
        },
      ),
      GoRoute(
        path: '/referentiel/conjugation/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return ConjugationDetailScreen(conjugationId: id);
        },
      ),
      GoRoute(
        path: '/referentiel/declension/:id',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return DeclensionDetailScreen(declensionId: id);
        },
      ),
      GoRoute(
        path: '/referentiel/studio/conjugation',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final record = state.extra is ConjugationRecord
              ? state.extra as ConjugationRecord
              : null;
          return ConjugationEditorScreen(initialRecord: record);
        },
      ),
      GoRoute(
        path: '/referentiel/studio/declension',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final record = state.extra is DeclensionRecord
              ? state.extra as DeclensionRecord
              : null;
          return DeclensionEditorScreen(initialRecord: record);
        },
      ),
      GoRoute(
        path: '/referentiel/studio/lesson',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final record = state.extra is GrammarLessonRecord
              ? state.extra as GrammarLessonRecord
              : null;
          return LessonEditorScreen(initialRecord: record);
        },
      ),
      GoRoute(
        path: '/referentiel/studio/import',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const BundleImportExportScreen(),
      ),
    ],
  );
});
