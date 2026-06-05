import 'dart:io';
import 'package:dermascan/core/utils/image_quality_evaluator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('flags very dark images', () async {
    final file = await _writeImage(img.Image(width: 32, height: 32));

    final result = await ImageQualityEvaluator.evaluate(file);

    expect(result.isAcceptable, isFalse);
    expect(result.message, contains('too dark'));
  });

  test('accepts a bright image with contrast', () async {
    final image = img.Image(width: 32, height: 32);
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < image.width; x++) {
        final value = (x + y).isEven ? 90 : 190;
        image.setPixelRgb(x, y, value, value, value);
      }
    }
    final file = await _writeImage(image);

    final result = await ImageQualityEvaluator.evaluate(file);

    expect(result.isAcceptable, isTrue);
  });
}

Future<File> _writeImage(img.Image image) async {
  final file = File('${Directory.systemTemp.path}/quality_${DateTime.now().microsecondsSinceEpoch}.jpg');
  await file.writeAsBytes(img.encodeJpg(image));
  return file;
}
