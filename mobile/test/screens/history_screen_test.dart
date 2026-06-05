import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dermascan/core/cubit/scan_history_cubit.dart';
import 'package:dermascan/core/cubit/scan_history_states.dart';
import 'package:dermascan/core/models/scan_model.dart';
import 'package:dermascan/core/services/scan_repository.dart';
import 'package:dermascan/screens/history_screen.dart';

void main() {
  group('HistoryScreen', () {
    Widget buildWithCubit(ScanHistoryState initialState) {
      final cubit = _TestCubit();
      cubit.emit(initialState);
      return BlocProvider<ScanHistoryCubit>.value(
        value: cubit,
        child: Builder(
          builder: (context) => MaterialApp(home: HistoryScreen()),
        ),
      );
    }

    testWidgets('shows empty state when no scans', (tester) async {
      await tester.pumpWidget(buildWithCubit(const ScanHistoryLoaded([])));
      expect(find.text('No scans yet'), findsOneWidget);
    });

    testWidgets('shows scan list when scans exist', (tester) async {
      await tester.pumpWidget(buildWithCubit(ScanHistoryLoaded([
        ScanModel(
          id: '1',
          imagePath: 'x',
          classification: 'Acne',
          confidence: 0.92,
          createdAt: DateTime(2026, 5, 26),
        ),
      ])));
      expect(find.text('Acne'), findsOneWidget);
      expect(find.text('92% confidence • Routine'), findsOneWidget);
    });

    testWidgets('shows error state with retry button', (tester) async {
      await tester.pumpWidget(
          buildWithCubit(const ScanHistoryError('Network error')));
      expect(find.text('Failed to load history'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}

class _TestCubit extends ScanHistoryCubit {
  _TestCubit() : super(repository: _FakeRepo());
  @override
  Future<void> loadHistory() async {}
}

class _FakeRepo implements ScanRepository {
  @override
  Future<List<ScanModel>> fetchHistory() async => [];
  @override
  Future<void> syncScan({
    required String imagePath,
    required String classification,
    required double confidence,
  }) async {}
}
