import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;
import '../models/image_quality.dart';

class ImageQualityEvaluator {
  ImageQualityEvaluator._();

  static Future<ImageQualityResult> evaluate(File imageFile) async {
    final decoded = img.decodeImage(await imageFile.readAsBytes());
    if (decoded == null) {
      return const ImageQualityResult(
        isAcceptable: false,
        message: 'Image could not be read. Try another photo.',
      );
    }

    final sample = img.copyResize(decoded, width: 96);
    final stats = _stats(sample);

    if (stats.averageBrightness < 58) {
      return const ImageQualityResult(
        isAcceptable: false,
        message: 'Image too dark. Try brighter lighting.',
      );
    }
    if (stats.averageBrightness > 235) {
      return const ImageQualityResult(
        isAcceptable: false,
        message: 'Image too bright. Try softer, even lighting.',
      );
    }
    if (stats.edgeScore < 4.2) {
      return const ImageQualityResult(
        isAcceptable: false,
        message: 'Image looks blurry. Hold steady and try again.',
      );
    }

    return const ImageQualityResult(isAcceptable: true);
  }

  static _QualityStats _stats(img.Image image) {
    var brightnessTotal = 0.0;
    var edgeTotal = 0.0;
    var edgeCount = 0;

    double luminanceAt(int x, int y) {
      final pixel = image.getPixel(x, y);
      return (0.299 * pixel.r) + (0.587 * pixel.g) + (0.114 * pixel.b);
    }

    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        brightnessTotal += luminanceAt(x, y);
        if (x > 0 && y > 0) {
          final current = luminanceAt(x, y);
          final left = luminanceAt(x - 1, y);
          final top = luminanceAt(x, y - 1);
          edgeTotal += math.max((current - left).abs(), (current - top).abs());
          edgeCount++;
        }
      }
    }

    return _QualityStats(
      averageBrightness: brightnessTotal / (image.width * image.height),
      edgeScore: edgeCount == 0 ? 0 : edgeTotal / edgeCount,
    );
  }
}

class _QualityStats {
  const _QualityStats({
    required this.averageBrightness,
    required this.edgeScore,
  });

  final double averageBrightness;
  final double edgeScore;
}
