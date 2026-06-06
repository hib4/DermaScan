import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Apple-style form text input.
class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? maxLength;

  const CustomTextField({
    super.key,
    this.controller,
    this.labelText,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.keyboardType,
    this.inputFormatters,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null) ...[
          Text(
            labelText!,
            style: theme.textTheme.labelSmall?.copyWith(color: AppColors.mute),
          ),
          const SizedBox(height: 8),
        ],
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 50),
          child: CupertinoTextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            onChanged: onChanged,
            maxLines: obscureText ? 1 : maxLines,
            maxLength: maxLength,
            placeholder: hintText ?? labelText,
            prefix: prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: prefixIcon,
                  ),
            suffix: suffixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: suffixIcon,
                  ),
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            style: AppTextStyles.body.copyWith(color: AppColors.ink),
            placeholderStyle: AppTextStyles.body.copyWith(color: AppColors.mute),
            cursorColor: AppColors.primary,
            decoration: BoxDecoration(
              color: AppColors.surfacePearl,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: errorText == null ? AppColors.dividerSoft : AppColors.accentRed,
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText!,
            style: theme.textTheme.labelSmall?.copyWith(color: AppColors.accentRed),
          ),
        ],
      ],
    );
  }
}
