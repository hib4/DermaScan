import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../core/extensions/navigator_extensions.dart';
import '../../core/models/condition_info.dart';
import '../../theme/app_colors.dart';
import '../../widgets/disclaimer_banner.dart';
import '../../widgets/health_info_card.dart';
import '../../widgets/primary_button.dart';
import 'camera_screen.dart';

class ScanEntryScreen extends StatelessWidget {
  const ScanEntryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(24, 26 + MediaQuery.paddingOf(context).top, 24, 110 + MediaQuery.paddingOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Scan', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              'Take or upload a clear photo of the skin area. The flow is short and you can retake before analysis.',
              style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.mute),
            ),
            const SizedBox(height: 28),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(color: AppColors.surfaceBlack),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(CupertinoIcons.camera, color: AppColors.primaryOnDark, size: 34),
                  const SizedBox(height: 28),
                  Text(
                    'Center the lesion. Keep the phone steady.',
                    style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Use bright, even lighting and keep the entire visible area inside the frame.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.76),
                    ),
                  ),
                  const SizedBox(height: 24),
                  PrimaryButton(
                    text: 'Open Camera',
                    onPressed: () => context.push(const CameraScreen()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const DisclaimerBanner(),
            const SizedBox(height: 26),
            Text('Image guidance', style: theme.textTheme.titleSmall),
            const SizedBox(height: 12),
            ...ConditionLibrary.scanTips.map(
              (tip) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: HealthInfoCard(
                  icon: CupertinoIcons.check_mark_circled,
                  title: tip,
                  body: 'This helps the model evaluate visual patterns more consistently.',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
