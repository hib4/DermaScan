import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';

class ImagePreviewCard extends StatelessWidget {
  const ImagePreviewCard({
    super.key,
    required this.imagePath,
    this.imageUrl,
    this.height = 260,
  });

  final String imagePath;
  final String? imageUrl;
  final double height;

  @override
  Widget build(BuildContext context) {
    final isNetworkImage = imageUrl != null && imageUrl!.startsWith('http');
    final file = File(imagePath);
    final hasLocalImage = imagePath.isNotEmpty && file.existsSync();

    Widget? imageWidget;
    if (isNetworkImage) {
      imageWidget = Image.network(
        imageUrl!,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _placeholder(),
      );
    } else if (hasLocalImage) {
      imageWidget = Image.file(file, fit: BoxFit.cover);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        height: height,
        color: AppColors.canvasParchment,
        child: imageWidget ?? _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return const Center(
      child: Icon(CupertinoIcons.photo, size: 42, color: AppColors.mute),
    );
  }
}
