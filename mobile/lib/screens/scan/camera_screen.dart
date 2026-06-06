import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../core/extensions/navigator_extensions.dart';
import '../../core/utils/image_quality_evaluator.dart';
import '../../theme/app_colors.dart';
import 'processing_screen.dart';
import '../../core/services/camera_service.dart';
import '../../widgets/quality_warning_card.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/secondary_button.dart';
import '../../widgets/app_toast.dart';

/// Camera screen with preview, frame guide, capture, and gallery upload.
class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> with WidgetsBindingObserver {
  final _cameraService = CameraService.instance;
  final _picker = ImagePicker();

  bool _isInitializing = true;
  bool _isCapturing = false;
  String? _error;

  String? _qualityWarning;

  Timer? _qualityCheckTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _qualityCheckTimer?.cancel();
    _cameraService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_cameraService.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraService.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      await _cameraService.initializeCamera();
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _error = null;
        });
        _startQualityChecks();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isInitializing = false;
          _error = e.toString();
        });
      }
    }
  }

  void _startQualityChecks() {
    _qualityCheckTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      // Placeholder: real implementation would analyze brightness/blur
      // from camera stream frames. For now, no warning.
      if (mounted) {
        setState(() => _qualityWarning = null);
      }
    });
  }

  Future<void> _capturePhoto() async {
    if (_isCapturing || !_cameraService.isInitialized) return;

    setState(() => _isCapturing = true);

    try {
      final xFile = await _cameraService.capturePicture();
      if (!mounted) return;

      await _continueWithImage(xFile.path);
    } catch (e) {
      if (mounted) {
        showAppToast(context, 'Failed to capture: $e', isError: true);
      }
    } finally {
      if (mounted) {
        setState(() => _isCapturing = false);
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null || !mounted) return;

      await _continueWithImage(image.path);
    } catch (e) {
      if (mounted) {
        showAppToast(context, 'Failed to pick image: $e', isError: true);
      }
    }
  }

  Future<void> _continueWithImage(String imagePath) async {
    final quality = await ImageQualityEvaluator.evaluate(File(imagePath));
    if (!mounted) return;

    if (quality.isAcceptable) {
      context.push(ProcessingScreen(imagePath: imagePath));
      return;
    }

    setState(() => _qualityWarning = quality.message);
    final proceed = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QualityWarningCard(
                message: quality.message ?? 'Image quality could be improved. Try another photo.',
              ),
              const SizedBox(height: 18),
              PrimaryButton(
                text: 'Retake Photo',
                onPressed: () => Navigator.of(context).pop(false),
              ),
              const SizedBox(height: 10),
              SecondaryButton(
                text: 'Analyze Anyway',
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          ),
        ),
      ),
    );

    if (proceed == true && mounted) {
      context.push(ProcessingScreen(imagePath: imagePath));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CupertinoActivityIndicator(color: AppColors.primary),
              const SizedBox(height: 16),
              Text(
                'Initializing camera...',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return _buildErrorState();
    }

    return Scaffold(
      backgroundColor: AppColors.surfaceBlack,
      body: Stack(
        children: [
          // Camera preview
          _cameraService.controller != null
              ? CameraPreview(_cameraService.controller!)
              : const SizedBox.shrink(),

          // Top bar with close button
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CupertinoButton(
                      minimumSize: const Size(44, 44),
                      padding: EdgeInsets.zero,
                      onPressed: () => context.pop(),
                      child: const Icon(CupertinoIcons.xmark, color: Colors.white),
                    ),
                    if (_qualityWarning != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              CupertinoIcons.info_circle,
                              color: AppColors.accentOrange,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _qualityWarning!,
                              style: const TextStyle(
                                color: AppColors.ink,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),

          // Center frame guide
          Center(
            child: CustomPaint(
              painter: _FrameGuidePainter(),
              child: SizedBox(
                width: 280,
                height: 280,
              ),
            ),
          ),

          // Bottom control bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 24,
                ),
                color: Colors.black.withValues(alpha: 0.52),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Gallery button
                    CupertinoButton(
                      onPressed: _pickFromGallery,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(48, 48),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.16),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.5),
                            width: 1.5,
                          ),
                        ),
                        child: const Icon(
                          CupertinoIcons.photo_on_rectangle,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),

                    // Capture button
                    SizedBox(
                      width: 120,
                      child: PrimaryButton(
                        text: 'Capture',
                        onPressed: _isCapturing ? null : _capturePhoto,
                        isLoading: _isCapturing,
                      ),
                    ),

                    // Spacer for symmetry
                    const SizedBox(width: 48),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  CupertinoIcons.camera,
                  size: 64,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'Camera unavailable',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: 200,
                  child: PrimaryButton(
                    text: 'Try Again',
                    onPressed: () {
                      setState(() {
                        _isInitializing = true;
                        _error = null;
                      });
                      _initializeCamera();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Paints a rounded rectangular frame guide in the center of the screen.
class _FrameGuidePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const radius = Radius.circular(16);
    final rrect = RRect.fromRectAndRadius(rect, radius);

    canvas.drawRRect(rrect, paint);

    // Corner accents
    final cornerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const cornerLength = 20.0;
    // Top-left
    canvas.drawLine(Offset(0, cornerLength), Offset.zero, cornerPaint);
    canvas.drawLine(Offset(cornerLength, 0), Offset.zero, cornerPaint);
    // Top-right
    canvas.drawLine(
      Offset(size.width - cornerLength, 0),
      Offset(size.width, 0),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, cornerLength),
      Offset(size.width, 0),
      cornerPaint,
    );
    // Bottom-left
    canvas.drawLine(
      Offset(0, size.height - cornerLength),
      Offset(0, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(cornerLength, size.height),
      Offset(0, size.height),
      cornerPaint,
    );
    // Bottom-right
    canvas.drawLine(
      Offset(size.width - cornerLength, size.height),
      Offset(size.width, size.height),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(size.width, size.height - cornerLength),
      Offset(size.width, size.height),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
