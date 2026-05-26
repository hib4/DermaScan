import 'package:equatable/equatable.dart';

/// Represents a completed skin scan prediction.
class ScanResult extends Equatable {
  final String imagePath;
  final String predictedLabel;
  final double confidence;
  final List<double> allConfidences;

  const ScanResult({
    required this.imagePath,
    required this.predictedLabel,
    required this.confidence,
    required this.allConfidences,
  });

  @override
  List<Object?> get props => [imagePath, predictedLabel, confidence, allConfidences];
}

/// Status of the scanning pipeline.
enum ScanStatus { initial, loading, success, error }
