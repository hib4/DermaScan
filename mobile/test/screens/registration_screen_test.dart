import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:dermascan/core/cubit/auth_cubit.dart';
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/services/auth_service.dart';
import 'package:dermascan/core/services/storage_provider.dart';
import 'package:dermascan/screens/registration_screen.dart';
import 'package:dermascan/widgets/primary_button.dart';

class _FakeStorage implements StorageProvider {
  @override
  Future<String?> getToken() async => null;
  @override
  Future<void> setToken(String v) async {}
  @override
  Future<void> deleteToken() async {}
}

void main() {
  group('RegistrationScreen', () {
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
          child: MaterialApp(home: RegistrationScreen()),
        );

    testWidgets('shows email, password, and confirm password fields',
        (tester) async {
      await tester.pumpWidget(build());
      expect(find.byType(TextFormField), findsNWidgets(3));
    });

    testWidgets('shows snackbar when passwords do not match', (tester) async {
      await tester.pumpWidget(build());
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'password123');
      await tester.enterText(fields.at(2), 'different');
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump(); // First pump to show snackbar
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('shows snackbar when password too short', (tester) async {
      await tester.pumpWidget(build());
      final fields = find.byType(TextFormField);
      await tester.enterText(fields.at(1), 'short');
      await tester.enterText(fields.at(2), 'short');
      await tester.tap(find.byType(PrimaryButton));
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
