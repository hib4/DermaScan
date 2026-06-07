import 'package:dermascan/core/network/api_config.dart';
import 'package:equatable/equatable.dart';

class ScanModel extends Equatable {
  final String id;
  final String imagePath;
  final String? imageUrl;
  final String classification;
  final double confidence;
  final DateTime createdAt;

  const ScanModel({
    required this.id,
    required this.imagePath,
    this.imageUrl,
    required this.classification,
    required this.confidence,
    required this.createdAt,
  });

  factory ScanModel.fromJson(Map<String, dynamic> json) {
    final rawPath = json['image_path'] as String? ?? '';
    String? imageUrl = json['image_url'] as String?;
    // If backend didn't provide image_url but image_path looks like a server path, build it
    if (imageUrl == null && rawPath.isNotEmpty && !rawPath.startsWith('/') && !rawPath.startsWith('http')) {
      final filename = rawPath.split('/').last;
      imageUrl = '${ApiConfig.baseUrl}/uploads/$filename';
    }
    return ScanModel(
      id: json['id'] as String? ?? '',
      imagePath: rawPath,
      imageUrl: imageUrl,
      classification: json['classification'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'image_path': imagePath,
        'image_url': imageUrl,
        'classification': classification,
        'confidence': confidence,
        'created_at': createdAt.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, imagePath, imageUrl, classification, confidence, createdAt];
}
