import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

void showAppToast(
  BuildContext context,
  String message, {
  bool isError = false,
}) {
  final overlay = Overlay.maybeOf(context, rootOverlay: true);
  if (overlay == null) return;

  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => Positioned(
      left: 20,
      right: 20,
      bottom: 34 + MediaQuery.viewPaddingOf(context).bottom,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: isError
                ? AppColors.accentRed.withValues(alpha: 0.94)
                : AppColors.strongText(context).withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
            child: Row(
              children: [
                Icon(
                  isError
                      ? CupertinoIcons.exclamationmark_circle
                      : CupertinoIcons.check_mark_circled,
                  color: AppColors.onPrimary,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    message,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(entry);
  Future<void>.delayed(const Duration(seconds: 3), () {
    if (entry.mounted) entry.remove();
  });
}
