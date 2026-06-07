import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import '../models/scan_state.dart';
import '../services/scan_repository.dart';
import '../services/tflite_service.dart';
import '../utils/image_processor.dart';
import '../utils/app_logger.dart';

class ScanCubit extends Cubit<ScanResult?> {
  ScanCubit({required ScanRepository scanRepository})
      : _scanRepository = scanRepository,
        super(null);

  final _tfliteService = TfliteService.instance;
  final ScanRepository _scanRepository;
  final _logger = AppLogger.scan;

  /// Run the full inference pipeline: preprocess → predict.
  ///
  /// [imagePath] is the file path of the captured/picked image.
  Future<void> runInference(String imagePath) async {
    emit(null);
    final sw = Stopwatch()..start();

    try {
      _logger.i('Starting inference: ${imagePath.split('/').last}');

      if (!_tfliteService.isInitialized) {
        _logger.d('TFLite model not initialized, loading now…');
        final t0 = Stopwatch()..start();
        await _tfliteService.initialize();
        _logger.d('TFLite initialized in ${t0.elapsedMilliseconds}ms');
      }

      _logger.t('Step 1: Preprocessing image');
      final p0 = Stopwatch()..start();
      final file = File(imagePath);
      final tensor = await ImageProcessor.preprocessImage(file);
      _logger.t('Preprocessing done in ${p0.elapsedMilliseconds}ms (tensor length: ${tensor.length})');

      _logger.t('Step 2: Running TFLite prediction');
      final p1 = Stopwatch()..start();
      final prediction = await _tfliteService.predict(tensor);
      _logger.t('Prediction done in ${p1.elapsedMilliseconds}ms → ${prediction.label} (${(prediction.confidence * 100).toStringAsFixed(1)}%)');

      emit(ScanResult(
        imagePath: imagePath,
        predictedLabel: prediction.label,
        confidence: prediction.confidence,
        allConfidences: prediction.allConfidences,
      ));

      _logger.d('Full inference completed in ${sw.elapsedMilliseconds}ms');

      // Fire-and-forget background sync to backend
      _syncToBackend(imagePath, prediction.label, prediction.confidence);
    } catch (e, st) {
      _logger.e('Inference FAILED after ${sw.elapsedMilliseconds}ms', error: e, stackTrace: st);
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
    _logger.d('Syncing to backend: $classification (${(confidence * 100).toStringAsFixed(1)}%)');
    _scanRepository
        .syncScan(
          imagePath: imagePath,
          classification: classification,
          confidence: confidence,
        )
        .then(
          (_) => _logger.d('Backend sync successful'),
          onError: (e, st) => _logger.e('Backend sync failed', error: e, stackTrace: st),
        );
  }

  /// Clear the current scan result.
  void reset() => emit(null);
}
