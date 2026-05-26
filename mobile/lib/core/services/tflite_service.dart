import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

/// Singleton service for running TFLite inference on preprocessed skin images.
class TfliteService {
  TfliteService._();
  static final TfliteService instance = TfliteService._();

  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  /// Load the model and labels from assets. Safe to call multiple times.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      final labelsText = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsText
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      _isInitialized = true;
    } catch (e) {
      throw StateError('Failed to initialize TFLite model: $e');
    }
  }

  /// Run inference on a preprocessed image tensor.
  ///
  /// [tensor] is the Float32List from ImageProcessor (224x224x3, ImageNet normalized).
  /// Returns the top predicted label and its confidence (0.0–1.0).
  Future<({String label, double confidence, List<double> allConfidences})> predict(
    Float32List tensor,
  ) async {
    if (!_isInitialized || _interpreter == null || _labels == null) {
      throw StateError('TfliteService not initialized. Call initialize() first.');
    }

    // Reshape input to [1, 224, 224, 3] for the model
    final input = tensor.reshape([1, 224, 224, 3]);

    // Output buffer: [1, 7] for 7 classes
    final output = List.filled(1 * _labels!.length, 0.0).reshape([1, _labels!.length]);

    // Run inference
    _interpreter!.run(input, output);

    // Extract the single output row
    final rawOutput = output[0] as List<double>;
    final allConfidences = List<double>.from(rawOutput);

    // Find the index with highest confidence
    var maxIndex = 0;
    var maxConfidence = allConfidences[0];
    for (var i = 1; i < allConfidences.length; i++) {
      if (allConfidences[i] > maxConfidence) {
        maxConfidence = allConfidences[i];
        maxIndex = i;
      }
    }

    return (
      label: _labels![maxIndex],
      confidence: maxConfidence,
      allConfidences: allConfidences,
    );
  }

  /// Release TFLite interpreter resources.
  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
    _isInitialized = false;
  }
}
