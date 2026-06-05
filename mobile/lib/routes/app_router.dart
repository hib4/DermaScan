import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../screens/onboarding_screen.dart';
import '../screens/registration_screen.dart';
import '../screens/results_screen.dart';
import '../core/models/scan_model.dart';
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
        final scan = settings.arguments is ScanModel
            ? settings.arguments as ScanModel
            : null;
        return MaterialPageRoute(builder: (_) => ResultsScreen(scan: scan));
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
    return const ScaffoldWithNavBar();
  }
}
