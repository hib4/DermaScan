import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../core/cubit/auth_cubit.dart';
import '../core/cubit/auth_states.dart';
import '../core/cubit/scan_history_cubit.dart';
import '../core/network/api_client.dart';
import '../core/services/scan_repository.dart';
import '../core/services/secure_storage_service.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/results_screen.dart';
import '../screens/scan/camera_screen.dart';
import '../screens/scan/processing_screen.dart';
import '../screens/settings_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static GoRouter createConfig({
    required String initialLocation,
    required AuthCubit authCubit,
  }) =>
      GoRouter(
        navigatorKey: _rootNavigatorKey,
        initialLocation: initialLocation,
        redirect: (context, state) {
          final auth = authCubit.state;
          final isAuth = auth is AuthAuthenticated;
          final isAuthRoute = state.matchedLocation == AppConstants.login ||
              state.matchedLocation == AppConstants.onboarding ||
              state.matchedLocation == AppConstants.registration;
          if (!isAuth && !isAuthRoute) return AppConstants.login;
          if (isAuth && isAuthRoute) return AppConstants.home;
          return null;
        },
        routes: [
          GoRoute(
            path: AppConstants.onboarding,
            builder: (_, __) => const OnboardingScreen(),
          ),
          GoRoute(
            path: AppConstants.login,
            builder: (_, __) => const LoginScreen(),
          ),
          GoRoute(
            path: AppConstants.registration,
            builder: (_, __) => const RegistrationScreen(),
          ),
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) {
              final storage = SecureStorageService.instance;
              final apiClient = ApiClient(storage: storage);
              return BlocProvider(
                create: (_) => ScanHistoryCubit(
                    repository: ScanRepository(apiClient: apiClient)),
                child: ScaffoldWithNavBar(
                    shell: child as StatefulNavigationShell),
              );
            },
            routes: [
              GoRoute(
                path: AppConstants.home,
                parentNavigatorKey: _shellNavigatorKey,
                builder: (_, __) => const HomeScreen(),
              ),
              GoRoute(
                path: AppConstants.history,
                parentNavigatorKey: _shellNavigatorKey,
                builder: (_, __) => const HistoryScreen(),
              ),
              GoRoute(
                path: AppConstants.settings,
                parentNavigatorKey: _shellNavigatorKey,
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: AppConstants.camera,
            builder: (_, __) => const CameraScreen(),
          ),
          GoRoute(
            path: AppConstants.processing,
            builder: (_, state) =>
                ProcessingScreen(imagePath: state.uri.queryParameters['path']),
          ),
          GoRoute(
            path: AppConstants.results,
            builder: (_, __) => const ResultsScreen(),
          ),
        ],
      );
}
