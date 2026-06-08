import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class AnalysisLoadingState extends StatefulWidget {
  const AnalysisLoadingState({super.key});

  @override
  State<AnalysisLoadingState> createState() => _AnalysisLoadingStateState();
}

class _AnalysisLoadingStateState extends State<AnalysisLoadingState> {
  static const _messages = [
    'Analyzing image quality...',
    'Checking visual patterns...',
    'Preparing screening result...',
  ];

  int _index = 0;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  Future<void> _tick() async {
    while (mounted && _index < _messages.length - 1) {
      await Future<void>.delayed(const Duration(milliseconds: 1200));
      if (mounted) setState(() => _index++);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoActivityIndicator(
              radius: 18,
              color: AppColors.primaryInteractive(context),
            ),
            const SizedBox(height: 28),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 260),
              child: Text(
                _messages[_index],
                key: ValueKey(_index),
                style: theme.textTheme.titleSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'This screening is informational and does not replace professional medical advice.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.mutedText(context),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
