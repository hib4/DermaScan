import 'package:flutter/material.dart';

/// Primary CTA button — Action Blue pill with white text.
/// Supports enabled, disabled, and loading states.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDisabled = onPressed == null;
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isDisabled
            ? theme.colorScheme.onSurface.withValues(alpha: 0.12)
            : theme.colorScheme.primary,
        foregroundColor: isDisabled
            ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
            : theme.colorScheme.onPrimary,
        minimumSize: const Size(44, 50),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        elevation: 0,
      ),
      child: isLoading
          ? SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  isDisabled
                      ? theme.colorScheme.onSurface.withValues(alpha: 0.38)
                      : theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Text(text),
    );
  }
}
