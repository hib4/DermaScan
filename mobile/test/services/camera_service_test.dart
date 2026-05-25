import 'package:dermascan/core/services/camera_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CameraService', () {
    test('returns the same singleton instance', () {
      final instance1 = CameraService.instance;
      final instance2 = CameraService.instance;
      expect(identical(instance1, instance2), isTrue);
    });

    test('has no initialized camera by default', () {
      final service = CameraService.instance;
      expect(service.isInitialized, isFalse);
      expect(service.controller, isNull);
    });
  });
}
