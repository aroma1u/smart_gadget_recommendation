import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Screens
import '../screens/auth_screen.dart';
import '../screens/home_screen.dart';
import '../screens/recommendation_form_screen.dart';
import '../screens/recommendation_results_screen.dart';
import '../screens/comparison_screen.dart';
import '../screens/details_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/favorites_screen.dart';
import '../screens/admin_dashboard.dart';
import '../providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isDummyLoggedIn = ref.read(mockBypassLoginProvider);
      if (isDummyLoggedIn) {
        if (state.uri.toString() == '/login') return '/';
        return null; // allow access
      }

      var isAuth = false;
      var isLoading = false;
      try {
        final authState = ref.read(authStateChangesProvider);
        isLoading = authState.isLoading;
        isAuth = authState.value != null;
      } catch (_) {}

      if (isLoading) return null;

      final isLoggingIn = state.uri.toString() == '/login';

      if (!isAuth && !isLoggingIn) return '/login';
      if (isAuth && isLoggingIn) return '/';

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const AuthScreen()),
      GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const RecommendationFormScreen(),
      ),
      GoRoute(
        path: '/recommend',
        builder: (context, state) {
          final initial = state.extra as String?;
          return RecommendationFormScreen(initialCategory: initial);
        },
      ),
      GoRoute(
        path: '/results',
        builder: (context, state) => const RecommendationResultsScreen(),
      ),
      GoRoute(
        path: '/compare',
        builder: (context, state) => const ComparisonScreen(),
      ),
      GoRoute(
        path: '/details/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailsScreen(id: id);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/admin',
        builder: (context, state) => const AdminDashboard(),
      ),
      GoRoute(
        path: '/favorites',
        builder: (context, state) => const FavoritesScreen(),
      ),
    ],
  );

  ref.listen(authStateChangesProvider, (_, _) {
    router.refresh();
  });

  ref.listen(mockBypassLoginProvider, (_, _) {
    router.refresh();
  });

  return router;
});
