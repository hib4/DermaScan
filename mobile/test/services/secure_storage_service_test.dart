import 'package:flutter_test/flutter_test.dart';
import 'package:dermascan/core/services/storage_provider.dart';

void main() {
  group('FakeStorageProvider', () {
    test('stores and retrieves token', () async {
      final storage = FakeStorageProvider();
      expect(await storage.getToken(), isNull);
      await storage.setToken('test-jwt');
      expect(await storage.getToken(), 'test-jwt');
    });
    test('deletes token', () async {
      final storage = FakeStorageProvider();
      await storage.setToken('abc');
      await storage.deleteToken();
      expect(await storage.getToken(), isNull);
    });
  });
}

class FakeStorageProvider implements StorageProvider {
  String? _token;
  @override
  Future<String?> getToken() async => _token;
  @override
  Future<void> setToken(String t) async => _token = t;
  @override
  Future<void> deleteToken() async => _token = null;
}
