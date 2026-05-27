import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../core/cubit/auth_cubit.dart';
import '../core/cubit/auth_states.dart';
import '../widgets/custom_text_field.dart';
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
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Create Account',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign up to get started',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
              const SizedBox(height: 40),
              CustomTextField(
                controller: _email,
                labelText: 'Email',
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
                    context.go(AppConstants.shell);
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
                        onPressed: loading ? null : () => context.go(AppConstants.login),
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
