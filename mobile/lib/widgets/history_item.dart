import 'package:flutter/material.dart';
import '../core/models/condition_info.dart';
import '../core/models/scan_model.dart';
import '../theme/app_colors.dart';
import 'image_preview_card.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({
    super.key,
    required this.scan,
    required this.onTap,
  });

  final ScanModel scan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = ConditionLibrary.forLabel(scan.classification);
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: theme.dividerColor),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 68,
                height: 68,
                child: ImagePreviewCard(imagePath: scan.imagePath, height: 68),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(scan.classification, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text(
                      '${(scan.confidence * 100).toStringAsFixed(0)}% confidence • ${info.riskLevel.label}',
                      style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mute),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(scan.createdAt),
                      style: theme.textTheme.labelSmall?.copyWith(color: AppColors.mute),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.mute),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
