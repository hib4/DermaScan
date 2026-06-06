import 'package:dermascan/core/cubit/auth_cubit.dart';
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/services/auth_service.dart';
import 'package:dermascan/core/services/scan_repository.dart';
import 'package:dermascan/core/services/storage_provider.dart';
import 'package:dermascan/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;

class _TestStorage implements StorageProvider {
  @override
  Future<String?> getToken() async => null;
  @override
  Future<void> setToken(String t) async {}
  @override
  Future<void> deleteToken() async {}
}

void main() {
  testWidgets('App renders DermaScanApp with CupertinoApp', (tester) async {
    final storage = _TestStorage();
    final apiClient = ApiClient(
      client: MockClient((_) async => http.Response('{}', 200)),
      storage: storage,
    );
    final authCubit = AuthCubit(
      authService: AuthService(apiClient: apiClient, storage: storage),
    );
    final scanRepo = ScanRepository(apiClient: apiClient);

    await tester.pumpWidget(DermaScanApp(
      authCubit: authCubit,
      scanRepository: scanRepo,
    ));
    expect(find.byType(CupertinoApp), findsOneWidget);
  });
}
