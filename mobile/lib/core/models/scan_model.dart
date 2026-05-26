import 'package:equatable/equatable.dart';

class ScanModel extends Equatable {
  final String id;
  final String imagePath;
  final String classification;
  final double confidence;
  final DateTime createdAt;

  const ScanModel({
    required this.id,
    required this.imagePath,
    required this.classification,
    required this.confidence,
    required this.createdAt,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json['id'] as String,
        imagePath: json['image_path'] as String,
        classification: json['classification'] as String,
        confidence: (json['confidence'] as num).toDouble(),
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image_path': imagePath,
        'classification': classification,
        'confidence': confidence,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, imagePath, classification, confidence, createdAt];
}
