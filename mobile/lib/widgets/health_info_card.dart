import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class HealthInfoCard extends StatelessWidget {
  const HealthInfoCard({
    super.key,
    required this.title,
    required this.body,
    this.icon,
    this.onTap,
  });

  final String title;
  final String body;
  final IconData? icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.elevatedSurface(context),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.softBorder(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.primaryInteractive(context), size: 24),
            const SizedBox(height: 20),
          ],
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.mutedText(context),
            ),
          ),
        ],
      ),
    );

    if (onTap == null) return content;
    return CupertinoButton(
      onPressed: onTap,
      padding: EdgeInsets.zero,
      minimumSize: const Size(44, 44),
      borderRadius: BorderRadius.circular(22),
      child: content,
    );
  }
}
