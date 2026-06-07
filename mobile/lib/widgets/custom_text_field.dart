import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Apple-style form text input matching DESIGN.md `search-input` spec.
///
/// - Background: canvas (#FFFFFF) per `search-input` spec.
/// - Border: 1px soft hairline `rgba(0, 0, 0, 0.08)` at rest.
/// - Focus border: 2px `primary-focus` (#0071E3) on focus.
/// - Error border: `accentRed` on error.
/// - Pill shape (`rounded.pill` — 999px radius).
/// - Padding: 12px vertical × 20px horizontal, height 44px.
class CustomTextField extends StatefulWidget {
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
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late final FocusNode _focusNode;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = _focusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  Color get _borderColor {
    if (widget.errorText != null) return AppColors.accentRed;
    if (_isFocused) return AppColors.primaryFocus;
    return AppColors.hairlineSoft;
  }

  double get _borderWidth {
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Text(
            widget.labelText!,
            style: theme.textTheme.labelSmall?.copyWith(color: AppColors.mute),
          ),
          const SizedBox(height: 8),
        ],
        ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 44),
          child: CupertinoTextField(
            focusNode: _focusNode,
            controller: widget.controller,
            obscureText: widget.obscureText,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            onChanged: widget.onChanged,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            placeholder: widget.hintText ?? widget.labelText,
            prefix: widget.prefixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: widget.prefixIcon,
                  ),
            suffix: widget.suffixIcon == null
                ? null
                : Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: widget.suffixIcon,
                  ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
            style: AppTextStyles.body.copyWith(color: AppColors.ink),
            placeholderStyle: AppTextStyles.body.copyWith(color: AppColors.mute),
            cursorColor: AppColors.primary,
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: _borderColor,
                width: _borderWidth,
              ),
            ),
          ),
        ),
        if (widget.errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            widget.errorText!,
            style: theme.textTheme.labelSmall?.copyWith(color: AppColors.accentRed),
          ),
        ],
      ],
    );
  }
}
