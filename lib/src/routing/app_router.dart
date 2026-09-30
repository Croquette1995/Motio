import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/learning_engine/presentation/dashboard_screen.dart';
import '../features/learning_engine/presentation/session_screen.dart';
import '../features/vocabulary/presentation/category_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/vocabulary',
        name: 'vocabulary',
        builder: (context, state) => const CategoryScreen(),
      ),
      GoRoute(
        path: '/session',
        name: 'session',
        builder: (context, state) => const SessionScreen(),
      ),
    ],
  );
});
