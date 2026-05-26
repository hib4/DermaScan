import 'package:dermascan/core/models/scan_model.dart';
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/network/api_config.dart';

class ScanRepository {
  final ApiClient _apiClient;
  ScanRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<List<ScanModel>> fetchHistory() async {
    final resp = await _apiClient.get(ApiConfig.scans);
    return (resp as List<dynamic>)
        .map((e) => ScanModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<void> syncScan({
    required String imagePath,
    required String classification,
    required double confidence,
  }) async {
    await _apiClient.postMultipart(
      ApiConfig.scans,
      imagePath,
      fields: {
        'classification': classification,
        'confidence': confidence.toStringAsFixed(4),
      },
    );
  }
}
