import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import '../theme/app_colors.dart';

class ImagePreviewCard extends StatelessWidget {
  const ImagePreviewCard({
    super.key,
    required this.imagePath,
    this.imageData,
    this.height = 260,
  });

  final String imagePath;
  final String? imageData;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hasDataUri = imageData != null && imageData!.isNotEmpty;
    final file = File(imagePath);
    final hasLocalImage = imagePath.isNotEmpty && file.existsSync();

    Widget? imageWidget;
    if (hasDataUri) {
      // Decode data URI: "data:image/jpeg;base64,..." or raw base64
      final raw = imageData!.contains(',')
          ? imageData!.split(',').last
          : imageData!;
      try {
        final bytes = base64Decode(raw);
        imageWidget = Image.memory(bytes, fit: BoxFit.cover);
      } catch (e) {
        // Fall through to placeholder
      }
    } else if (hasLocalImage) {
      imageWidget = Image.file(file, fit: BoxFit.cover);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        height: height,
        color: AppColors.subtleSurface(context),
        child: imageWidget ?? _placeholder(context),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
    return Center(
      child: Icon(
        CupertinoIcons.photo,
        size: 42,
        color: AppColors.mutedIcon(context),
      ),
    );
  }
}
