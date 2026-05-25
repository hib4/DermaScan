import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/utils/image_processor.dart';
import '../../core/constants/app_constants.dart';

/// Loading screen displayed during image preprocessing.
class ProcessingScreen extends StatefulWidget {
  final String? imagePath;

  const ProcessingScreen({super.key, this.imagePath});

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  @override
  void initState() {
    super.initState();
    _processImage();
  }

  Future<void> _processImage() async {
    if (widget.imagePath == null) {
      if (mounted) {
        context.go(AppConstants.home);
      }
      return;
    }

    try {
      final file = File(widget.imagePath!);
      // Preprocess image (floatBuffer will be passed to TFLite in Phase 3)
      await ImageProcessor.preprocessImage(file);

      if (!mounted) return;

      // Navigate to results with the processed data
      // Phase 3 (TFLite) will pass floatBuffer to the model
      context.push(AppConstants.results);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to process image: $e')),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Analyzing image...',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preparing your photo for AI detection',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
