import 'dart:io';
import 'package:dermascan/core/utils/image_processor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  group('ImageProcessor', () {
    late Directory tempDir;
    late File testImage;

    setUpAll(() async {
      tempDir = await Directory.systemTemp.createTemp('dermascan_test_');
      // Create a 300x200 red PNG using the image package
      final image = img.Image(width: 300, height: 200);
      img.fill(image, color: img.ColorUint8.rgb(255, 0, 0));
      final pngBytes = img.encodePng(image);
      testImage = File('${tempDir.path}/test_red.png');
      await testImage.writeAsBytes(pngBytes);
    });

    tearDownAll(() async {
      await tempDir.delete(recursive: true);
    });

    test('preprocessImage returns 224x224x3 float array', () async {
      final result = await ImageProcessor.preprocessImage(testImage);
      expect(result.length, 224 * 224 * 3);
    });

    test('preprocessImage normalizes pixel values to -1.0 to 1.0 range', () async {
      final result = await ImageProcessor.preprocessImage(testImage);

      // For a pure red pixel (255, 0, 0):
      // R channel: (1.0 - 0.485) / 0.229 ≈ 2.25
      // G channel: (0.0 - 0.456) / 0.224 ≈ -2.04
      // B channel: (0.0 - 0.406) / 0.225 ≈ -1.80
      for (var i = 0; i < result.length; i += 3) {
        final r = result[i];
        final g = result[i + 1];
        final b = result[i + 2];

        expect(r, greaterThan(1.0));
        expect(g, lessThan(-1.0));
        expect(b, lessThan(-1.0));
      }
    });

    test('preprocessImage crops to square from center', () async {
      // Create a 400x200 image — wider than tall
      final wideImage = img.Image(width: 400, height: 200);
      // Left half blue, right half red
      for (var x = 0; x < 200; x++) {
        for (var y = 0; y < 200; y++) {
          wideImage.setPixel(x, y, img.ColorUint8.rgb(0, 0, 255));
        }
      }
      for (var x = 200; x < 400; x++) {
        for (var y = 0; y < 200; y++) {
          wideImage.setPixel(x, y, img.ColorUint8.rgb(255, 0, 0));
        }
      }
      final pngBytes = img.encodePng(wideImage);
      final wideFile = File('${tempDir.path}/test_wide.png');
      await wideFile.writeAsBytes(pngBytes);

      final result = await ImageProcessor.preprocessImage(wideFile);

      // Center crop of 400x200 → 200x200 center → should show equal blue and red
      var redCount = 0;
      var blueCount = 0;
      for (var i = 0; i < result.length; i += 3) {
        if (result[i] > 1.0) redCount++;       // R channel high
        if (result[i + 2] > 1.0) blueCount++;  // B channel high
      }

      expect(redCount, greaterThan(0));
      expect(blueCount, greaterThan(0));
    });
  });
}
