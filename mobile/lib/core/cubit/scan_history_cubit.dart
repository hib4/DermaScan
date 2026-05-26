import 'package:bloc/bloc.dart';
import 'package:dermascan/core/services/scan_repository.dart';
import 'scan_history_states.dart';

class ScanHistoryCubit extends Cubit<ScanHistoryState> {
  final ScanRepository _repo;
  ScanHistoryCubit({required ScanRepository repository})
      : _repo = repository,
        super(ScanHistoryInitial());

  Future<void> loadHistory() async {
    emit(ScanHistoryLoading());
    try {
      emit(ScanHistoryLoaded(await _repo.fetchHistory()));
    } catch (e) {
      emit(ScanHistoryError(e.toString()));
    }
  }
}
