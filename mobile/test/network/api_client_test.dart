import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/services/storage_provider.dart';

void main() {
  group('ApiClient', () {
    final storage = _FakeStorage();

    test('get returns decoded JSON on 200 with Bearer header', () async {
      final mock = _FakeStorage(token: 'tok');
      final client = MockClient((request) async {
        expect(request.headers['Authorization'], 'Bearer tok');
        return http.Response(jsonEncode({'ok': true}), 200);
      });
      final api = ApiClient(client: client, storage: mock);
      expect(await api.get('/test'), {'ok': true});
    });

    test('get throws AuthException on 401', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode({'detail': 'No'}), 401));
      expect(
        () => ApiClient(client: client, storage: storage).get('/x'),
        throwsA(isA<AuthException>()),
      );
    });

    test('post throws ConflictException on 409', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode({'detail': 'Dup'}), 409));
      expect(
        () => ApiClient(client: client, storage: storage).post('/x', {}),
        throwsA(isA<ConflictException>()),
      );
    });

    test('postForm sends form-encoded body', () async {
      String? body;
      final client = MockClient((request) async {
        body = request.body;
        return http.Response('{}', 200);
      });
      final api = ApiClient(
          client: client, storage: _FakeStorage(token: 't'));
      await api.postForm('/login', {'email': 'a@b.com', 'password': 'pw'});
      expect(body, contains('email=a%40b.com'));
      expect(body, contains('password=pw'));
    });

    test('post sends JSON content type', () async {
      String? ct;
      final client = MockClient((request) async {
        ct = request.headers['Content-Type'];
        return http.Response('{}', 200);
      });
      await ApiClient(client: client, storage: storage).post('/x', {});
      expect(ct, 'application/json');
    });

    test('throws ServerException on 500', () async {
      final client = MockClient((_) async =>
          http.Response(jsonEncode({'detail': 'err'}), 500));
      expect(
        () => ApiClient(client: client, storage: storage).get('/x'),
        throwsA(isA<ServerException>()),
      );
    });
  });
}

class _FakeStorage implements StorageProvider {
  final String? token;
  _FakeStorage({this.token});
  @override
  Future<String?> getToken() async => token;
  @override
  Future<void> setToken(String t) async {}
  @override
  Future<void> deleteToken() async {}
}
