import 'package:flutter/material.dart';
import '../theme/app_shadows.dart';

/// Reusable quiet utility surface.
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
    final shadows = elevationLevel >= 4 ? AppShadows.byLevel(elevationLevel) : AppShadows.flat;

    Widget card = Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: theme.dividerColor),
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
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(18),
              ),
            ),
          ),
          Expanded(child: card),
        ],
      );
    }

    if (onTap != null) {
      card = Material(
        color: Colors.transparent,
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          child: card,
        ),
      );
    }

    return card;
  }
}
