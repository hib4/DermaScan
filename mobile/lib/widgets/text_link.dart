import 'package:flutter/material.dart';

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
        ? const Color(0xFF2997FF)
        : Theme.of(context).colorScheme.primary;
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: color,
        minimumSize: const Size(44, 44),
        padding: const EdgeInsets.symmetric(horizontal: 8),
      ),
      child: Text(text),
    );
  }
}
