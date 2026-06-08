import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/models/condition_info.dart';
import '../core/models/scan_model.dart';
import '../theme/app_colors.dart';
import 'image_preview_card.dart';

class HistoryItem extends StatelessWidget {
  const HistoryItem({super.key, required this.scan, required this.onTap});

  final ScanModel scan;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = ConditionLibrary.forLabel(scan.classification);
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.elevatedSurface(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: AppColors.softBorder(context)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 68,
              height: 68,
              child: ImagePreviewCard(
                imagePath: scan.imagePath ?? '',
                imageData: scan.imageData,
                height: 68,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scan.classification,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${(scan.confidence * 100).toStringAsFixed(0)}% confidence • ${info.riskLevel.label}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.mutedText(context),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(scan.createdAt),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.mutedText(context),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              CupertinoIcons.chevron_right,
              color: AppColors.mutedIcon(context),
              size: 18,
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
