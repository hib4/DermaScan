import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:dermascan/core/cubit/auth_cubit.dart';
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/services/auth_service.dart';
import 'package:dermascan/core/services/storage_provider.dart';
import 'package:dermascan/screens/login_screen.dart';

class _FakeStorage implements StorageProvider {
  @override
  Future<String?> getToken() async => null;
  @override
  Future<void> setToken(String v) async {}
  @override
  Future<void> deleteToken() async {}
}

void main() {
  group('LoginScreen', () {
    late AuthCubit cubit;

    setUp(() {
      final storage = _FakeStorage();
      final client = MockClient((_) async => http.Response('{}', 200));
      final api = ApiClient(client: client, storage: storage);
      cubit = AuthCubit(
        authService: AuthService(apiClient: api, storage: storage),
      );
    });

    Widget build() => BlocProvider.value(
          value: cubit,
          child: MaterialApp(home: LoginScreen()),
        );

    testWidgets('shows email and password fields', (tester) async {
      await tester.pumpWidget(build());
      expect(find.text('Sign in'), findsOneWidget);
      expect(find.byType(CupertinoTextField), findsNWidgets(2));
    });

    testWidgets('shows error when fields are empty', (tester) async {
      await tester.pumpWidget(build());
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      expect(find.text('Please fill in all fields'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));
    });
  });
}
