import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../core/extensions/navigator_extensions.dart';
import '../routes/app_router.dart';
import 'scan/camera_screen.dart';
import '../core/cubit/scan_cubit.dart';
import '../core/cubit/scan_history_cubit.dart';
import '../core/models/condition_info.dart';
import '../core/models/scan_model.dart';
import '../core/models/scan_state.dart';
import '../theme/app_colors.dart';
import '../widgets/disclaimer_banner.dart';
import '../widgets/health_info_card.dart';
import '../widgets/image_preview_card.dart';
import '../widgets/primary_button.dart';
import '../widgets/result_card.dart';
import '../widgets/secondary_button.dart';
import '../widgets/app_toast.dart';
import 'result_detail_screen.dart';

class ResultsScreen extends StatelessWidget {
  final ScanModel? scan;
  const ResultsScreen({super.key, this.scan});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = context.watch<ScanCubit>().state;
    final viewModel = _ResultViewModel.from(scan: scan, result: result);

    if (viewModel == null) {
      return Scaffold(
        appBar: CupertinoNavigationBar(
          middle: const Text('Results'),
          backgroundColor: AppColors.background(context),
          border: Border(
            bottom: BorderSide(color: AppColors.softBorder(context)),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                CupertinoIcons.exclamationmark_circle,
                size: 48,
                color: AppColors.mutedIcon(context),
              ),
              const SizedBox(height: 16),
              Text(
                'No screening result available',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.mutedText(context),
                ),
              ),
              const SizedBox(height: 16),
              SecondaryButton(
                text: 'Try Again',
                onPressed: () {
                  context.read<ScanCubit>().reset();
                  context.pushAndRemoveUntil(
                    const CameraScreen(),
                    (route) => route.settings.name == '/',
                  );
                },
              ),
            ],
          ),
        ),
      );
    }

    final condition = ConditionLibrary.forLabel(viewModel.label);
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      appBar: CupertinoNavigationBar(
        middle: const Text('Result'),
        backgroundColor: AppColors.background(context),
        border: Border(
          bottom: BorderSide(color: AppColors.softBorder(context)),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(24, 16, 24, 34 + bottomPadding),
        children: [
          ImagePreviewCard(
            imagePath: viewModel.imagePath,
            imageData: viewModel.imageData,
          ),
          const SizedBox(height: 18),
          ResultCard(condition: condition, confidence: viewModel.confidence),
          const SizedBox(height: 18),
          const DisclaimerBanner(),
          const SizedBox(height: 18),
          HealthInfoCard(
            title: 'Recommended next steps',
            body: condition.seekHelp,
            icon: CupertinoIcons.heart,
          ),
          const SizedBox(height: 12),
          HealthInfoCard(
            title: 'What DermaScan checked',
            body:
                'The app compared visual patterns in the image against supported screening categories. Clinical context, symptoms, and examination are not included.',
            icon: CupertinoIcons.sparkles,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: condition.riskLevel == RiskLevel.high
                ? 'Review Next Steps'
                : 'Learn More',
            onPressed: () =>
                context.push(ResultDetailScreen(condition: condition)),
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            text: 'Save Result',
            onPressed: () {
              context.read<ScanHistoryCubit>().loadHistory();
              showAppToast(
                context,
                'Result sync is saved to history when online.',
              );
            },
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            text: 'Scan Again',
            onPressed: () {
              context.read<ScanCubit>().reset();
              context.pushAndRemoveUntil(
                const CameraScreen(),
                (route) => route.settings.name == '/',
              );
            },
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            text: 'Home',
            onPressed: () => context.pushReplacement(const ShellRoute()),
          ),
        ],
      ),
    );
  }
}

class _ResultViewModel {
  const _ResultViewModel({
    required this.imagePath,
    this.imageData,
    required this.label,
    required this.confidence,
  });

  final String imagePath;
  final String? imageData;
  final String label;
  final double confidence;

  static _ResultViewModel? from({
    required ScanModel? scan,
    required ScanResult? result,
  }) {
    if (scan != null) {
      return _ResultViewModel(
        imagePath: scan.imagePath ?? '',
        imageData: scan.imageData,
        label: scan.classification,
        confidence: scan.confidence,
      );
    }
    if (result != null) {
      return _ResultViewModel(
        imagePath: result.imagePath,
        label: result.predictedLabel,
        confidence: result.confidence,
      );
    }
    return null;
  }
}
