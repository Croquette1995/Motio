import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/learning_engine/presentation/dashboard_screen.dart';
import '../features/learning_engine/presentation/session_screen.dart';
import '../features/practice_canvas/presentation/digital_ink_init_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/vocabulary/presentation/category_screen.dart';
import '../features/vocabulary/presentation/tatoeba_explorer_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/init',
    routes: [
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/init',
        name: 'init',
        builder: (context, state) => const DigitalInkInitScreen(),
      ),
      GoRoute(
        path: '/vocabulary',
        name: 'vocabulary',
        builder: (context, state) => const CategoryScreen(),
      ),
      GoRoute(
        path: '/tatoeba',
        name: 'tatoeba',
        builder: (context, state) => const TatoebaExplorerScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/session',
        name: 'session',
        builder: (context, state) => const SessionScreen(),
      ),
    ],
  );
});
