import 'dart:io';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class ImagePreviewCard extends StatelessWidget {
  const ImagePreviewCard({
    super.key,
    required this.imagePath,
    this.height = 260,
  });

  final String imagePath;
  final double height;

  @override
  Widget build(BuildContext context) {
    final file = File(imagePath);
    final hasLocalImage = imagePath.isNotEmpty && file.existsSync();
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: double.infinity,
        height: height,
        color: AppColors.canvasParchment,
        child: hasLocalImage
            ? Image.file(file, fit: BoxFit.cover)
            : const Center(
                child: Icon(Icons.image_outlined, size: 42, color: AppColors.mute),
              ),
      ),
    );
  }
}
