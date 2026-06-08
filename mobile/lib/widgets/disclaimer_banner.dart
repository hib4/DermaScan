import 'package:flutter/material.dart';
import '../core/models/condition_info.dart';
import '../theme/app_colors.dart';

class DisclaimerBanner extends StatelessWidget {
  const DisclaimerBanner({
    super.key,
    this.text = ConditionLibrary.generalDisclaimer,
    this.onDark = false,
  });

  final String text;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final color = onDark ? Colors.white : AppColors.bodyText(context);
    return Semantics(
      label: text,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: onDark
              ? Colors.white.withValues(alpha: 0.09)
              : AppColors.elevatedSurface(context),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: onDark
                ? Colors.white.withValues(alpha: 0.16)
                : AppColors.softBorder(context),
          ),
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: color.withValues(alpha: onDark ? 0.86 : 0.72),
          ),
        ),
      ),
    );
  }
}
