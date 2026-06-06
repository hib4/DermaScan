import 'package:flutter/material.dart';
import '../core/models/condition_info.dart';
import '../theme/app_colors.dart';

class ResultCard extends StatelessWidget {
  const ResultCard({
    super.key,
    required this.condition,
    required this.confidence,
  });

  final ConditionInfo condition;
  final double confidence;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final riskColor = switch (condition.riskLevel) {
      RiskLevel.high => AppColors.accentRed,
      RiskLevel.elevated => AppColors.accentOrange,
      RiskLevel.routine => AppColors.accentGreen,
    };

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfacePearl,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(condition.resultLead, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mute)),
          const SizedBox(height: 10),
          Text(condition.label, style: theme.textTheme.headlineMedium),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _Metric(
                  label: 'Confidence',
                  value: '${(confidence * 100).toStringAsFixed(1)}%',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _Metric(
                  label: 'Urgency',
                  value: condition.riskLevel.label,
                  valueColor: riskColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(condition.overview, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: condition.riskLevel == RiskLevel.high
                  ? AppColors.accentRed.withValues(alpha: 0.08)
                  : AppColors.canvas,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.dividerSoft),
            ),
            child: Text(
              condition.riskLevel.nextStep,
              style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.dividerSoft),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: AppColors.mute)),
          const SizedBox(height: 5),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: valueColor ?? AppColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
