import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../utils/app_logger.dart';

/// Singleton service for running TFLite inference on preprocessed skin images.
class TfliteService {
  TfliteService._();
  static final TfliteService instance = TfliteService._();

  Interpreter? _interpreter;
  List<String>? _labels;
  bool _isInitialized = false;
  int _outputSize = 0;
  final _logger = AppLogger.scan;

  bool get isInitialized => _isInitialized;

  /// Load the model and labels from assets. Safe to call multiple times.
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _logger.d('Loading TFLite model from assets/model.tflite');
      _interpreter = await Interpreter.fromAsset('assets/model.tflite');
      _logger.d('Loading labels from assets/labels.txt');
      final labelsText = await rootBundle.loadString('assets/labels.txt');
      _labels = labelsText
          .split('\n')
          .map((l) => l.trim())
          .where((l) => l.isNotEmpty)
          .toList();

      _isInitialized = true;

      // Read actual output tensor shape from the model
      final outputTensor = _interpreter!.getOutputTensor(0);
      _outputSize = outputTensor.shape.reduce((a, b) => a * b);

      final labelCount = _labels!.length;
      if (_outputSize != labelCount) {
        throw StateError(
          'Model output size ($_outputSize) differs from labels count ($labelCount). '
          'Update assets/model.tflite and assets/labels.txt together.',
        );
      }
      _logger.i('TFLite model loaded — output: ${outputTensor.shape}, labels: $labelCount');
    } catch (e, st) {
      _logger.e('Failed to load TFLite model', error: e, stackTrace: st);
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

    // Output buffer shaped from actual model output tensor, not labels file
    final output = List.filled(1 * _outputSize, 0.0).reshape([1, _outputSize]);

    try {
      // Run inference
      _interpreter!.run(input, output);
    } catch (e, st) {
      _logger.e('TFLite interpreter.run failed', error: e, stackTrace: st);
      rethrow;
    }

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

    _logger.t('Prediction: ${_labels![maxIndex]} (${(maxConfidence * 100).toStringAsFixed(1)}%), all: ${_formatConfidences(allConfidences)}');

    return (
      label: _labels![maxIndex],
      confidence: maxConfidence,
      allConfidences: allConfidences,
    );
  }

  String _formatConfidences(List<double> confs) {
    if (_labels == null) return confs.map((c) => c.toStringAsFixed(3)).join(', ');
    final count = confs.length < _labels!.length ? confs.length : _labels!.length;
    return List.generate(count, (i) => '${_labels![i]}=${confs[i].toStringAsFixed(3)}').join(', ');
  }

  /// Release TFLite interpreter resources.
  void dispose() {
    _logger.d('Disposing TFLite interpreter');
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
    _outputSize = 0;
    _isInitialized = false;
  }
}
