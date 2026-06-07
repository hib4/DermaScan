import 'package:equatable/equatable.dart';

class ScanModel extends Equatable {
  final String id;
  final String? imagePath;
  final String? imageData;
  final String classification;
  final double confidence;
  final DateTime createdAt;

  const ScanModel({
    required this.id,
    this.imagePath,
    this.imageData,
    required this.classification,
    required this.confidence,
    required this.createdAt,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
        id: json['id'] as String? ?? '',
        imagePath: json['image_path'] as String?,
        imageData: json['image_data'] as String?,
        classification: json['classification'] as String? ?? '',
        confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
        createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'image_path': imagePath,
        'image_data': imageData,
        'classification': classification,
        'confidence': confidence,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, imagePath, imageData, classification, confidence, createdAt];
}
