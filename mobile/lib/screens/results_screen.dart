import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../core/constants/app_constants.dart';
import '../core/cubit/scan_cubit.dart';
import '../core/models/scan_state.dart';
import '../theme/app_colors.dart';
import '../widgets/custom_card.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final result = context.watch<ScanCubit>().state;

    // Handle missing result gracefully
    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Results')),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline, size: 48, color: AppColors.mute),
              const SizedBox(height: 16),
              Text(
                'No analysis result available',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.bodyMid,
                ),
              ),
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () {
                  context.pop();
                  context.go(AppConstants.camera);
                },
                icon: const Icon(Icons.camera_alt),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Results')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image thumbnail card
            CustomCard(
              elevationLevel: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(result.imagePath),
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Classification result card
            CustomCard(
              elevationLevel: 2,
              accentColor: _getSeverityColor(result.confidence),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Predicted Classification',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.mute,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      result.predictedLabel,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: AppColors.ink,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Confidence score
                    Text(
                      'Confidence: ${(result.confidence * 100).toStringAsFixed(1)}%',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.body,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Confidence bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: result.confidence,
                        minHeight: 8,
                        backgroundColor: AppColors.hairline,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _getSeverityColor(result.confidence),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      context.pop();
                      context.go(AppConstants.camera);
                    },
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('New Scan'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.go(AppConstants.home),
                    icon: const Icon(Icons.home),
                    label: const Text('Home'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(double confidence) {
    if (confidence > 0.8) return AppColors.accentRed;
    if (confidence > 0.5) return AppColors.accentOrange;
    return AppColors.accentBlue;
  }
}
