import 'dart:io';
import 'package:bloc/bloc.dart';
import '../models/scan_state.dart';
import '../services/tflite_service.dart';
import '../utils/image_processor.dart';

class ScanCubit extends Cubit<ScanResult?> {
  ScanCubit() : super(null);

  final _tfliteService = TfliteService.instance;

  /// Run the full inference pipeline: preprocess → predict.
  ///
  /// [imagePath] is the file path of the captured/picked image.
  Future<void> runInference(String imagePath) async {
    emit(null); // Reset previous result

    try {
      // Ensure TFLite is initialized
      if (!_tfliteService.isInitialized) {
        await _tfliteService.initialize();
      }

      // Preprocess image (returns Float32List)
      final file = File(imagePath);
      final tensor = await ImageProcessor.preprocessImage(file);

      // Run inference
      final prediction = await _tfliteService.predict(tensor);

      emit(ScanResult(
        imagePath: imagePath,
        predictedLabel: prediction.label,
        confidence: prediction.confidence,
        allConfidences: prediction.allConfidences,
      ));
    } catch (e) {
      emit(null);
      rethrow;
    }
  }

  /// Clear the current scan result.
  void reset() => emit(null);
}
