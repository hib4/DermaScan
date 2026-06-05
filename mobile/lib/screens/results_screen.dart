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
        appBar: AppBar(title: const Text('Results')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.mute),
              const SizedBox(height: 16),
              Text(
                'No screening result available',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.bodyMid,
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
              onPressed: () => context.pushReplacement(const CameraScreen()),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    final condition = ConditionLibrary.forLabel(viewModel.label);
    return Scaffold(
      appBar: AppBar(title: const Text('Result')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 34),
        children: [
          ImagePreviewCard(imagePath: viewModel.imagePath),
          const SizedBox(height: 18),
          ResultCard(condition: condition, confidence: viewModel.confidence),
          const SizedBox(height: 18),
          const DisclaimerBanner(),
          const SizedBox(height: 18),
          HealthInfoCard(
            title: 'Recommended next steps',
            body: condition.seekHelp,
            icon: Icons.medical_services_outlined,
          ),
          const SizedBox(height: 12),
          HealthInfoCard(
            title: 'What DermaScan checked',
            body:
                'The app compared visual patterns in the image against supported screening categories. Clinical context, symptoms, and examination are not included.',
            icon: Icons.auto_awesome_outlined,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            text: condition.riskLevel == RiskLevel.high
                ? 'Review Next Steps'
                : 'Learn More',
            onPressed: () => context.push(ResultDetailScreen(condition: condition)),
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            text: 'Save Result',
            onPressed: () {
              context.read<ScanHistoryCubit>().loadHistory();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Result sync is saved to history when online.'),
                ),
              );
            },
          ),
          const SizedBox(height: 10),
          SecondaryButton(
            text: 'Scan Again',
            onPressed: () => context.pushReplacement(const CameraScreen()),
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
    required this.label,
    required this.confidence,
  });

  final String imagePath;
  final String label;
  final double confidence;

  static _ResultViewModel? from({
    required ScanModel? scan,
    required ScanResult? result,
  }) {
    if (scan != null) {
      return _ResultViewModel(
        imagePath: scan.imagePath,
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
