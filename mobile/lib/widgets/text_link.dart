import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

class TextLink extends StatelessWidget {
  const TextLink({
    super.key,
    required this.text,
    required this.onPressed,
    this.onDark = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool onDark;

  @override
  Widget build(BuildContext context) {
    final color = onDark
        ? AppColors.primaryOnDark
        : AppColors.primaryInteractive(context);
    return CupertinoButton(
      onPressed: onPressed,
      minimumSize: const Size(44, 44),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        text,
        style: AppTextStyles.body.copyWith(
          color: onPressed == null ? color.withValues(alpha: 0.45) : color,
        ),
      ),
    );
  }
}
