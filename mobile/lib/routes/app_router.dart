import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/cubit/scan_history_cubit.dart';
import '../core/network/api_client.dart';
import '../core/services/scan_repository.dart';
import '../core/services/secure_storage_service.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/results_screen.dart';
import '../screens/scan/camera_screen.dart';
import '../screens/scan/processing_screen.dart';
import '../widgets/scaffold_with_nav_bar.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const ShellRoute());
      case '/camera':
        return MaterialPageRoute(builder: (_) => const CameraScreen());
      case '/processing':
        final imagePath = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => ProcessingScreen(imagePath: imagePath),
        );
      case '/results':
        return MaterialPageRoute(builder: (_) => const ResultsScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegistrationScreen());
      case '/onboarding':
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('Route not found: ${settings.name}')),
          ),
        );
    }
  }
}

class ShellRoute extends StatelessWidget {
  const ShellRoute({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = SecureStorageService.instance;
    final apiClient = ApiClient(storage: storage);
    return BlocProvider(
      create: (_) => ScanHistoryCubit(repository: ScanRepository(apiClient: apiClient)),
      child: const ScaffoldWithNavBar(),
    );
  }
}
