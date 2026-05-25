import 'package:flutter/material.dart';
import '../theme/app_shadows.dart';

/// Reusable card surface with optional elevation and accent color bar.
class CustomCard extends StatelessWidget {
  final Widget child;
  final int elevationLevel;
  final Color? accentColor;
  final VoidCallback? onTap;

  const CustomCard({
    super.key,
    required this.child,
    this.elevationLevel = 1,
    this.accentColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shadows = AppShadows.byLevel(elevationLevel);
    final hasBorder = elevationLevel <= 1;

    Widget card = Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(8),
        border: hasBorder
            ? Border.all(color: theme.dividerColor)
            : null,
        boxShadow: shadows,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );

    if (accentColor != null) {
      card = Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 4,
            color: accentColor,
          ),
          Expanded(child: card),
        ],
      );
    }

    if (onTap != null) {
      card = InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: card,
      );
    }

    return card;
  }
}
