import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/services/auth_service.dart';
import 'package:dermascan/core/services/storage_provider.dart';
import 'package:dermascan/core/cubit/auth_cubit.dart';
import 'package:dermascan/core/cubit/auth_states.dart';

void main() {
  group('AuthCubit', () {
    late _FakeStorage storage;
    setUp(() => storage = _FakeStorage());

    AuthService _auth({required http.Client c}) =>
        AuthService(apiClient: ApiClient(client: c, storage: storage), storage: storage);

    blocTest<AuthCubit, AuthState>(
      'checkAuthStatus -> Unauthenticated when no token',
      build: () => AuthCubit(authService: _auth(c: MockClient((_) async => http.Response('{}', 200)))),
      act: (c) => c.checkAuthStatus(),
      expect: () => [isA<AuthLoading>(), isA<AuthUnauthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'checkAuthStatus -> Authenticated when token exists',
      setUp: () async => storage._t = 'tok',
      build: () => AuthCubit(authService: _auth(c: MockClient((_) async => http.Response('{}', 200)))),
      act: (c) => c.checkAuthStatus(),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'login success -> Authenticated',
      build: () => AuthCubit(authService: _auth(
        c: MockClient((_) async => http.Response(jsonEncode({'access_token': 'jwt'}), 200)))),
      act: (c) => c.login(email: 'a@b.com', password: 'pw'),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'login fail -> AuthError',
      build: () => AuthCubit(authService: _auth(
        c: MockClient((_) async => http.Response(jsonEncode({'detail': 'Bad creds'}), 401)))),
      act: (c) => c.login(email: 'a@b.com', password: 'x'),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );

    blocTest<AuthCubit, AuthState>(
      'register success -> Authenticated',
      build: () => AuthCubit(authService: _auth(
        c: MockClient((_) async => http.Response(jsonEncode({'access_token': 'jwt'}), 201)))),
      act: (c) => c.register(email: 'a@b.com', password: 'pw'),
      expect: () => [isA<AuthLoading>(), isA<AuthAuthenticated>()],
    );

    blocTest<AuthCubit, AuthState>(
      'register duplicate -> AuthError',
      build: () => AuthCubit(authService: _auth(
        c: MockClient((_) async => http.Response(jsonEncode({'detail': 'Dup'}), 409)))),
      act: (c) => c.register(email: 'a@b.com', password: 'pw'),
      expect: () => [isA<AuthLoading>(), isA<AuthError>()],
    );

    blocTest<AuthCubit, AuthState>(
      'logout -> Unauthenticated',
      setUp: () async => storage._t = 'tok',
      build: () => AuthCubit(authService: _auth(c: MockClient((_) async => http.Response('{}', 200)))),
      act: (c) => c.logout(),
      expect: () => [isA<AuthUnauthenticated>()],
    );
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
