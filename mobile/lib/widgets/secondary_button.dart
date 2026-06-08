import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

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
    final textColor = isDisabled
        ? AppColors.disabledText(context)
        : AppColors.primaryInteractive(context);

    return CupertinoButton(
      onPressed: isDisabled || isLoading ? null : onPressed,
      minimumSize: const Size(44, 50),
      borderRadius: BorderRadius.circular(999),
      padding: EdgeInsets.zero,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface(context),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isDisabled
                ? AppColors.disabledFill(context)
                : AppColors.border(context),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          child: Center(
            child: isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CupertinoActivityIndicator(),
                  )
                : Text(
                    text,
                    style: AppTextStyles.button.copyWith(color: textColor),
                  ),
          ),
        ),
      ),
    );
  }
}
