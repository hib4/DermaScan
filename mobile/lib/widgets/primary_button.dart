import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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

    return CupertinoButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      minimumSize: const Size(double.infinity, 50),
      borderRadius: BorderRadius.circular(999),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      color: isDisabled
          ? AppColors.ink.withValues(alpha: 0.12)
          : AppColors.primary,
      disabledColor: AppColors.ink.withValues(alpha: 0.12),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CupertinoActivityIndicator(color: AppColors.onPrimary),
            )
          : Text(
              text,
              style: AppTextStyles.button.copyWith(
                color: isDisabled
                    ? AppColors.ink.withValues(alpha: 0.38)
                    : AppColors.onPrimary,
              ),
            ),
    );
  }
}
