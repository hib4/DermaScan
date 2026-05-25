import 'package:flutter/material.dart';

/// Secondary CTA button — transparent background with hairline border.
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
            ? theme.colorScheme.onSurface.withOpacity(0.38)
            : theme.colorScheme.onSurface,
        side: BorderSide(
          color: isDisabled
              ? theme.colorScheme.onSurface.withOpacity(0.12)
              : theme.dividerColor,
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.onSurface.withOpacity(0.38),
                ),
              ),
            )
          : Text(text),
    );
  }
}
