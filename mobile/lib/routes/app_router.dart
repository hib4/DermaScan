import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../screens/onboarding_screen.dart';
import '../screens/login_screen.dart';
import '../screens/home_screen.dart';
import '../screens/history_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/camera_screen.dart';
import '../screens/results_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// go_router configuration for the DermaScan app.
class AppRouter {
  AppRouter._();

  static GoRouter get config => GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: AppConstants.onboarding,
        routes: [
          // Top-level routes (no shell)
          GoRoute(
            path: AppConstants.onboarding,
            builder: (_, __) => const OnboardingScreen(),
          ),
          GoRoute(
            path: AppConstants.login,
            builder: (_, __) => const LoginScreen(),
          ),

          // Shell route for bottom navigation
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) => ScaffoldWithNavBar(
              shell: child as StatefulNavigationShell,
            ),
            routes: [
              GoRoute(
                path: AppConstants.home,
                parentNavigatorKey: _shellNavigatorKey,
                builder: (_, __) => const HomeScreen(),
                routes: [
                  GoRoute(
                    path: AppConstants.history.substring(1),
                    parentNavigatorKey: _shellNavigatorKey,
                    builder: (_, __) => const HistoryScreen(),
                  ),
                  GoRoute(
                    path: AppConstants.settings.substring(1),
                    parentNavigatorKey: _shellNavigatorKey,
                    builder: (_, __) => const SettingsScreen(),
                  ),
                ],
              ),
            ],
          ),

          // Full-screen push routes
          GoRoute(
            path: AppConstants.camera,
            builder: (_, __) => const CameraScreen(),
          ),
          GoRoute(
            path: AppConstants.results,
            builder: (_, __) => const ResultsScreen(),
          ),
        ],
      );
}
