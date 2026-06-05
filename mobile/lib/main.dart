import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/constants/app_constants.dart';
import 'core/cubit/scan_cubit.dart';
import 'core/cubit/scan_history_cubit.dart';
import 'core/cubit/auth_cubit.dart';
import 'core/cubit/auth_states.dart';
import 'core/network/api_client.dart';
import 'core/services/auth_service.dart';
import 'core/services/scan_repository.dart';
import 'core/services/secure_storage_service.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  final storage = SecureStorageService.instance;
  final apiClient = ApiClient(storage: storage);
  final authService = AuthService(apiClient: apiClient, storage: storage);
  final authCubit = AuthCubit(authService: authService);
  final scanRepository = ScanRepository(apiClient: apiClient);

  await authCubit.checkAuthStatus();
  runApp(DermaScanApp(authCubit: authCubit, scanRepository: scanRepository));
}

class DermaScanApp extends StatelessWidget {
  final AuthCubit authCubit;
  final ScanRepository scanRepository;
  const DermaScanApp({super.key, required this.authCubit, required this.scanRepository});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: authCubit),
        BlocProvider(create: (_) => ScanCubit(scanRepository: scanRepository)),
        BlocProvider(create: (_) => ScanHistoryCubit(repository: scanRepository)),
      ],
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          final initialRoute = (authState is AuthAuthenticated)
              ? AppConstants.home
              : AppConstants.onboarding;
          return MaterialApp(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            initialRoute: initialRoute,
            onGenerateRoute: AppRouter.onGenerateRoute,
          );
        },
      ),
    );
  }
}
