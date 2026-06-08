import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/extensions/navigator_extensions.dart';
import '../core/cubit/scan_history_cubit.dart';
import '../core/cubit/scan_history_states.dart';
import '../core/models/condition_info.dart';
import 'learn_screen.dart';
import 'results_screen.dart';
import 'scan/camera_screen.dart';
import '../theme/app_colors.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/health_info_card.dart';
import '../widgets/history_item.dart';
import '../widgets/primary_button.dart';
import '../widgets/secondary_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<ScanHistoryCubit>();
    Future.microtask(cubit.loadHistory);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          24,
          26 + MediaQuery.paddingOf(context).top,
          24,
          110 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today',
              style: theme.textTheme.labelLarge?.copyWith(
                color: AppColors.mutedText(context),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Ready for a skin screening?',
              style: theme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            Text(
              'Capture a clear image and DermaScan will provide an informational AI screening result.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.mutedText(context),
              ),
            ),
            const SizedBox(height: 26),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.subtleSurface(context),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    CupertinoIcons.viewfinder,
                    color: AppColors.primaryInteractive(context),
                    size: 34,
                  ),
                  const SizedBox(height: 22),
                  Text('Scan Skin', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Use the camera or choose a photo from your gallery.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.mutedText(context),
                    ),
                  ),
                  const SizedBox(height: 22),
                  PrimaryButton(
                    text: 'Scan Skin',
                    onPressed: () => context.push(const CameraScreen()),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const DisclaimerBanner(),
            const SizedBox(height: 28),
            BlocBuilder<ScanHistoryCubit, ScanHistoryState>(
              builder: (context, state) {
                if (state is ScanHistoryLoaded && state.scans.isNotEmpty) {
                  final latest = state.scans.first;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Recent scan', style: theme.textTheme.titleSmall),
                      const SizedBox(height: 12),
                      HistoryItem(
                        scan: latest,
                        onTap: () => context.push(ResultsScreen(scan: latest)),
                      ),
                    ],
                  );
                }
                return HealthInfoCard(
                  icon: CupertinoIcons.lightbulb,
                  title: 'Skin health tip',
                  body: ConditionLibrary.scanTips.first,
                );
              },
            ),
            const SizedBox(height: 24),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.surfaceTile1,
                borderRadius: BorderRadius.circular(0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Know what changes matter.',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Watch for spots that change in size, shape, color, or begin to bleed or hurt.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.76),
                    ),
                  ),
                  const SizedBox(height: 18),
                  SecondaryButton(
                    text: 'Learn More',
                    onPressed: () => context.push(const LearnScreen()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
