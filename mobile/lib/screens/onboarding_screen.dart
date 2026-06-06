import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/extensions/navigator_extensions.dart';
import 'login_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: AppColors.surfaceBlack,
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: const BoxDecoration(color: AppColors.surfaceBlack),
              child: CustomPaint(painter: _SkinTexturePainter()),
            ),
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(28, 32, 28, 0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight - 56),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'DermaScan',
                          style: theme.textTheme.headlineLarge?.copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'AI-assisted skin screening, designed to be calm, fast, and medically responsible.',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.82),
                          ),
                        ),
                        const SizedBox(height: 34),
                        _OnboardingPoint(
                          icon: CupertinoIcons.camera,
                          title: 'Capture or upload',
                          body: 'Frame the skin area clearly in bright, even lighting.',
                        ),
                        _OnboardingPoint(
                          icon: CupertinoIcons.sparkles,
                          title: 'Screen visual patterns',
                          body: 'The model suggests a possible category with a confidence score.',
                        ),
                        _OnboardingPoint(
                          icon: CupertinoIcons.heart,
                          title: 'Learn what to do next',
                          body: 'Read plain-language information and seek care when appropriate.',
                        ),
                        const SizedBox(height: 28),
                        const DisclaimerBanner(onDark: true),
                        const SizedBox(height: 28),
                        PrimaryButton(
                          text: 'Get Started',
                          onPressed: () => context.pushReplacement(const LoginScreen()),
                        ),
                        const SizedBox(height: 10),
                        SecondaryButton(
                          text: 'I understand',
                          onPressed: () => context.pushReplacement(const LoginScreen()),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPoint extends StatelessWidget {
  const _OnboardingPoint({
    required this.icon,
    required this.title,
    required this.body,
  });

  final IconData icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 22),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryOnDark, size: 26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  body,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.72),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkinTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final center = Offset(size.width * 0.66, size.height * 0.24);
    for (var i = 0; i < 10; i++) {
      canvas.drawCircle(center, 48.0 + i * 28, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
