import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'app_logger.dart';

/// Image preprocessing pipeline for TFLite model input.
///
/// Pipeline: load → square center-crop → resize to 224x224 → ImageNet normalize.
class ImageProcessor {
  ImageProcessor._();
  static final _logger = AppLogger.scan;

  /// ImageNet normalization constants.
  static const _meanR = 0.485;
  static const _meanG = 0.456;
  static const _meanB = 0.406;
  static const _stdR = 0.229;
  static const _stdG = 0.224;
  static const _stdB = 0.225;

  /// Target model input size.
  static const int inputSize = 224;

  /// Preprocess an image file for TFLite inference.
  ///
  /// Returns a [Float32List] of length 224 * 224 * 3 (150,528 values)
  /// in RGB channel order, normalized using ImageNet mean/std.
  static Future<Float32List> preprocessImage(File imageFile) async {
    _logger.t('Loading image bytes: ${imageFile.path.split('/').last}');
    final bytes = await imageFile.readAsBytes();
    _logger.t('Image size: ${bytes.length} bytes');

    final decoded = img.decodeImage(bytes);
    if (decoded == null) {
      _logger.e('Unable to decode image: ${imageFile.path}');
      throw FormatException('Unable to decode image: ${imageFile.path}');
    }
    _logger.t('Image decoded: ${decoded.width}x${decoded.height}');

    // Step 1: Center-crop to square
    final square = _centerCrop(decoded);
    _logger.t('Center-cropped to ${square.width}x${square.height}');

    // Step 2: Resize to 224x224
    final resized = img.copyResize(
      square,
      width: inputSize,
      height: inputSize,
      interpolation: img.Interpolation.linear,
    );
    _logger.t('Resized to ${inputSize}x$inputSize');

    // Step 3: Normalize and flatten to Float32List
    final result = _normalize(resized);
    _logger.t('Normalized → Float32List[${result.length}]');
    return result;
  }

  /// Center-crop an image to a square using the smaller dimension.
  static img.Image _centerCrop(img.Image image) {
    final size = image.width < image.height ? image.width : image.height;
    final x = (image.width - size) ~/ 2;
    final y = (image.height - size) ~/ 2;
    return img.copyCrop(image, x: x, y: y, width: size, height: size);
  }

  /// Normalize image pixels using ImageNet mean/std and return as Float32List.
  ///
  /// Output layout: [R0, G0, B0, R1, G1, B1, ...] for all 224*224 pixels.
  static Float32List _normalize(img.Image image) {
    final result = Float32List(inputSize * inputSize * 3);
    // Access raw bytes: image 4.x stores pixels as Uint8List in RGBA order
    final bytes = image.getBytes(order: img.ChannelOrder.rgba);
    var idx = 0;
    var byteIdx = 0;

    for (var i = 0; i < inputSize * inputSize; i++) {
      final r = bytes[byteIdx] / 255.0;
      final g = bytes[byteIdx + 1] / 255.0;
      final b = bytes[byteIdx + 2] / 255.0;
      byteIdx += 4; // skip alpha

      result[idx++] = (r - _meanR) / _stdR;
      result[idx++] = (g - _meanG) / _stdG;
      result[idx++] = (b - _meanB) / _stdB;
    }

    return result;
  }
}
