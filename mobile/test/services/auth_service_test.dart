import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/services/auth_service.dart';
import 'package:dermascan/core/services/storage_provider.dart';

void main() {
  group('AuthService', () {
    late _FakeStorage storage;

    setUp(() => storage = _FakeStorage());

    AuthService _make({required http.Client c}) =>
        AuthService(apiClient: ApiClient(client: c, storage: storage), storage: storage);

    test('login stores token', () async {
      final c = MockClient((_) async =>
          http.Response(jsonEncode({'access_token': 'jwt'}), 200));
      await _make(c: c).login(email: 'a@b.com', password: 'pw');
      expect(await storage.getToken(), 'jwt');
    });

    test('login throws AuthException on 401', () async {
      final c = MockClient((_) async =>
          http.Response(jsonEncode({'detail': 'Bad'}), 401));
      expect(
        () => _make(c: c).login(email: 'a@b.com', password: 'x'),
        throwsA(isA<AuthException>()),
      );
    });

    test('register throws ConflictException on 409', () async {
      final c = MockClient((_) async =>
          http.Response(jsonEncode({'detail': 'Dup'}), 409));
      expect(
        () => _make(c: c).register(email: 'a@b.com', password: 'x'),
        throwsA(isA<ConflictException>()),
      );
    });

    test('logout clears token', () async {
      await storage.setToken('tok');
      final c = MockClient((_) async => http.Response('{}', 200));
      await _make(c: c).logout();
      expect(await storage.getToken(), isNull);
    });

    test('isAuthenticated true/false', () async {
      final c = MockClient((_) async => http.Response('{}', 200));
      final svc = _make(c: c);
      expect(await svc.isAuthenticated(), isFalse);
      await storage.setToken('tok');
      expect(await svc.isAuthenticated(), isTrue);
    });
  });
}

class _FakeStorage implements StorageProvider {
  String? _t;
  @override
  Future<String?> getToken() async => _t;
  @override
  Future<void> setToken(String v) async => _t = v;
  @override
  Future<void> deleteToken() async => _t = null;
}
