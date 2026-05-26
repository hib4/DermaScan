import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/services/scan_repository.dart';
import 'package:dermascan/core/services/storage_provider.dart';

void main() {
  group('ScanRepository', () {
    final storage = _FakeStorage();
    late File tempFile;

    setUp(() {
      tempFile = File('${Directory.systemTemp.path}/test_scan.jpg');
      tempFile.writeAsBytesSync([0, 1, 2, 3]);
    });

    tearDown(() {
      if (tempFile.existsSync()) tempFile.deleteSync();
    });

    test('fetchHistory parses scan list', () async {
      final c = MockClient((_) async => http.Response(jsonEncode([
            {
              'id': '1',
              'image_path': 'uploads/a.jpg',
              'classification': 'Acne',
              'confidence': 0.9,
              'created_at': '2026-05-26T10:00:00Z',
            },
          ]), 200));
      final scans =
          await ScanRepository(apiClient: ApiClient(client: c, storage: storage))
              .fetchHistory();
      expect(scans.length, 1);
      expect(scans[0].classification, 'Acne');
    });

    test('syncScan calls POST multipart', () async {
      String? path;
      final c = MockClient((req) async {
        path = req.url.path;
        return http.Response('{}', 201);
      });
      await ScanRepository(apiClient: ApiClient(client: c, storage: storage))
          .syncScan(
        imagePath: tempFile.path,
        classification: 'Acne',
        confidence: 0.85,
      );
      expect(path, contains('scans'));
    });
  });
}

class _FakeStorage implements StorageProvider {
  @override
  Future<String?> getToken() async => null;
  @override
  Future<void> setToken(String v) async {}
  @override
  Future<void> deleteToken() async {}
}
