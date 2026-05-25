import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

/// Singleton service managing the device camera.
class CameraService {
  CameraService._();

  static final CameraService instance = CameraService._();

  CameraController? _controller;
  bool _initialized = false;

  bool get isInitialized => _initialized;
  CameraController? get controller => _controller;

  /// Request camera permission from the OS.
  Future<bool> requestPermission() async {
    final status = await Permission.camera.request();
    return status.isGranted;
  }

  /// Initialize the rear (back) camera.
  Future<void> initializeCamera() async {
    if (!await requestPermission()) {
      throw CameraException('Permission denied', 'Camera permission was not granted');
    }

    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      throw CameraException('No cameras', 'No cameras available on this device');
    }

    final rearCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );

    _controller = CameraController(
      rearCamera,
      ResolutionPreset.high,
      enableAudio: false,
    );

    await _controller!.initialize();
    _initialized = true;
  }

  /// Capture a photo and return the image file.
  Future<XFile> capturePicture() async {
    if (!_initialized || _controller == null) {
      throw StateError('Camera is not initialized. Call initializeCamera() first.');
    }
    return _controller!.takePicture();
  }

  /// Dispose the camera controller and free resources.
  Future<void> dispose() async {
    await _controller?.dispose();
    _controller = null;
    _initialized = false;
  }
}
