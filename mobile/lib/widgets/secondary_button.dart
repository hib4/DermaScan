import 'package:flutter/material.dart';

/// Secondary CTA button — white pill with Action Blue text.
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final theme = Theme.of(context);

    return OutlinedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: isDisabled
            ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
            : theme.colorScheme.primary,
        side: BorderSide(
          color: isDisabled
              ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
              : theme.dividerColor,
        ),
        backgroundColor: theme.colorScheme.surface,
        minimumSize: const Size(44, 50),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onSurface.withValues(alpha: 0.38),
                ),
              ),
            )
          : Text(text),
    );
  }
}
