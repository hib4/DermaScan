import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/extensions/navigator_extensions.dart';
import 'login_screen.dart';
import '../core/cubit/auth_cubit.dart';
import '../theme/app_colors.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/health_info_card.dart';
import '../widgets/secondary_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          24,
          26 + MediaQuery.paddingOf(context).top,
          24,
          110 + MediaQuery.paddingOf(context).bottom,
        ),
        children: [
          Text('Profile', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 12),
          Text(
            'Account settings, privacy information, and app preferences.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.mutedText(context),
            ),
          ),
          const SizedBox(height: 24),
          const DisclaimerBanner(),
          const SizedBox(height: 22),
          const HealthInfoCard(
            icon: CupertinoIcons.person,
            title: 'Account',
            body: 'Signed in with email and password.',
          ),
          const SizedBox(height: 12),
          const HealthInfoCard(
            icon: CupertinoIcons.textformat_size,
            title: 'Accessibility',
            body:
                'DermaScan follows system text scaling and maintains large touch targets.',
          ),
          const SizedBox(height: 12),
          const HealthInfoCard(
            icon: CupertinoIcons.lock_shield,
            title: 'Privacy and disclaimer',
            body:
                'Screening results are informational. Images are uploaded to your account history when online.',
          ),
          const SizedBox(height: 24),
          SecondaryButton(
            text: 'Logout',
            onPressed: () => _showLogoutDialog(context),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          CupertinoDialogAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<AuthCubit>().logout();
              context.pushReplacement(const LoginScreen());
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
