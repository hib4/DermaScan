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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: theme.colorScheme.primary, size: 24),
            const SizedBox(height: 18),
          ],
          Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(body, style: theme.textTheme.bodySmall?.copyWith(color: AppColors.mute)),
        ],
      ),
    );

    if (onTap == null) return content;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(onTap: onTap, child: content),
    );
  }
}
