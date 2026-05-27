import 'package:flutter/material.dart';
import '../core/extensions/navigator_extensions.dart';
import 'login_screen.dart';
import '../widgets/primary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableHeight = constraints.maxHeight - 96; // account for padding
            final useCompact = availableHeight < 400;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: availableHeight > 0 ? availableHeight : 0),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (!useCompact) const Spacer(),
                      Text(
                        'SKIN ANALYSIS',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Detect skin conditions\nwith AI',
                        style: (useCompact ? theme.textTheme.titleLarge : theme.textTheme.headlineLarge)?.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Take a photo of your skin and get instant AI-powered analysis.',
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const Spacer(),
                      PrimaryButton(
                        text: 'Get Started',
                        onPressed: () => context.pushReplacement(const LoginScreen()),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
