import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'package:dermascan/core/network/api_client.dart';
import 'package:dermascan/core/services/scan_repository.dart';
import 'package:dermascan/core/services/storage_provider.dart';
import 'package:dermascan/core/cubit/scan_history_cubit.dart';
import 'package:dermascan/core/cubit/scan_history_states.dart';

void main() {
  group('ScanHistoryCubit', () {
    final storage = _FakeStorage();

    blocTest<ScanHistoryCubit, ScanHistoryState>(
      'loadHistory -> Loading then Loaded',
      build: () {
        final c = MockClient((_) async => http.Response(jsonEncode([
              {
                'id': '1',
                'image_path': 'x',
                'classification': 'A',
                'confidence': 0.9,
                'created_at': '2026-01-01T00:00:00Z',
              },
            ]), 200));
        return ScanHistoryCubit(
            repository: ScanRepository(apiClient: ApiClient(client: c, storage: storage)));
      },
      act: (c) => c.loadHistory(),
      expect: () => [isA<ScanHistoryLoading>(), isA<ScanHistoryLoaded>()],
    );

    blocTest<ScanHistoryCubit, ScanHistoryState>(
      'loadHistory -> Loading then Error',
      build: () {
        final c = MockClient((_) async =>
            http.Response(jsonEncode({'detail': 'No'}), 401));
        return ScanHistoryCubit(
            repository: ScanRepository(apiClient: ApiClient(client: c, storage: storage)));
      },
      act: (c) => c.loadHistory(),
      expect: () => [isA<ScanHistoryLoading>(), isA<ScanHistoryError>()],
    );
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
