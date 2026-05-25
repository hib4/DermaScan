import 'package:flutter/material.dart';

/// Primary CTA button — near-black background with white text.
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
            ? theme.colorScheme.onSurface.withOpacity(0.12)
            : theme.colorScheme.primary,
        foregroundColor: isDisabled
            ? theme.colorScheme.onSurface.withOpacity(0.38)
            : theme.colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
                      ? theme.colorScheme.onSurface.withOpacity(0.38)
                      : theme.colorScheme.onPrimary,
                ),
              ),
            )
          : Text(text),
    );
  }
}
