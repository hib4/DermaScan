import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/extensions/navigator_extensions.dart';
import '../routes/app_router.dart';
import 'registration_screen.dart';
import '../core/cubit/auth_cubit.dart';
import '../core/cubit/auth_states.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';
import '../widgets/text_link.dart';
import '../widgets/app_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onLogin() {
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      showAppToast(context, 'Please fill in all fields', isError: true);
      return;
    }
    context.read<AuthCubit>().login(email: email, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Sign in',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Continue to your scan history and saved screening results.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.68),
                ),
              ),
              const SizedBox(height: 30),
              const DisclaimerBanner(),
              const SizedBox(height: 28),
              CustomTextField(
                controller: _email,
                labelText: 'Email',
                hintText: 'name@example.com',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _password,
                labelText: 'Password',
                obscureText: true,
              ),
              const SizedBox(height: 32),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    showAppToast(context, state.message, isError: true);
                  } else if (state is AuthAuthenticated) {
                    context.pushReplacement(const ShellRoute());
                  }
                },
                builder: (context, state) {
                  final loading = state is AuthLoading;
                  return Column(
                    children: [
                      PrimaryButton(
                        text: 'Sign In',
                        onPressed: loading ? null : _onLogin,
                        isLoading: loading,
                      ),
                      const SizedBox(height: 10),
                      SecondaryButton(
                        text: 'Create Account',
                        onPressed: loading ? null : () => context.push(const RegistrationScreen()),
                      ),
                      const SizedBox(height: 12),
                      TextLink(
                        text: 'DermaScan uses email and password sign-in in this version.',
                        onPressed: null,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
