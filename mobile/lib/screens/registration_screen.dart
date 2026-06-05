import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/extensions/navigator_extensions.dart';
import '../routes/app_router.dart';
import 'login_screen.dart';
import '../core/cubit/auth_cubit.dart';
import '../core/cubit/auth_states.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  String? _validate() {
    if (_email.text.trim().isEmpty || !_email.text.contains('@')) {
      return 'Please enter a valid email';
    }
    if (_password.text.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (_password.text != _confirm.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _onRegister() {
    final err = _validate();
    if (err != null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }
    context.read<AuthCubit>().register(
          email: _email.text.trim(),
          password: _password.text,
        );
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
                'Create account',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Save screening results and review them later.',
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
              const SizedBox(height: 16),
              CustomTextField(
                controller: _confirm,
                labelText: 'Confirm Password',
                obscureText: true,
              ),
              const SizedBox(height: 32),
              BlocConsumer<AuthCubit, AuthState>(
                listener: (context, state) {
                  if (state is AuthError) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.message)),
                    );
                  } else if (state is AuthAuthenticated) {
                    context.pushReplacement(const ShellRoute());
                  }
                },
                builder: (context, state) {
                  final loading = state is AuthLoading;
                  return Column(
                    children: [
                      PrimaryButton(
                        text: 'Create Account',
                        onPressed: loading ? null : _onRegister,
                        isLoading: loading,
                      ),
                      const SizedBox(height: 12),
                      SecondaryButton(
                        text: 'Back to Login',
                        onPressed: loading ? null : () => context.pushReplacement(const LoginScreen()),
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
