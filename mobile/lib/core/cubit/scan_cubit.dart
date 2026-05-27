import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import '../models/scan_state.dart';
import '../services/scan_repository.dart';
import '../services/tflite_service.dart';
import '../utils/image_processor.dart';

class ScanCubit extends Cubit<ScanResult?> {
  ScanCubit({required ScanRepository scanRepository})
      : _scanRepository = scanRepository,
        super(null);

  final _tfliteService = TfliteService.instance;
  final ScanRepository _scanRepository;

  /// Run the full inference pipeline: preprocess → predict.
  ///
  /// [imagePath] is the file path of the captured/picked image.
  Future<void> runInference(String imagePath) async {
    emit(null);

    try {
      if (!_tfliteService.isInitialized) {
        await _tfliteService.initialize();
      }

      final file = File(imagePath);
      final tensor = await ImageProcessor.preprocessImage(file);
      final prediction = await _tfliteService.predict(tensor);

      emit(ScanResult(
        imagePath: imagePath,
        predictedLabel: prediction.label,
        confidence: prediction.confidence,
        allConfidences: prediction.allConfidences,
      ));

      // Fire-and-forget background sync to backend
      _syncToBackend(imagePath, prediction.label, prediction.confidence);
    } catch (e) {
      emit(null);
      rethrow;
    }
  }

  /// Uploads scan result to the backend without blocking the UI.
  /// Errors are logged but do not affect the local result.
  void _syncToBackend(
    String imagePath,
    String classification,
    double confidence,
  ) {
    print('[ScanCubit] Syncing to backend: $classification (${(confidence * 100).toStringAsFixed(1)}%)');
    _scanRepository
        .syncScan(
          imagePath: imagePath,
          classification: classification,
          confidence: confidence,
        )
        .then(
          (_) => print('[ScanCubit] Sync successful'),
          onError: (e, st) => print('[ScanCubit] Sync failed: $e'),
        );
  }

  /// Clear the current scan result.
  void reset() => emit(null);
}
