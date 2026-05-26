import 'package:equatable/equatable.dart';
import 'package:dermascan/core/models/scan_model.dart';

abstract class ScanHistoryState extends Equatable {
  const ScanHistoryState();
  @override
  List<Object?> get props => [];
}

class ScanHistoryInitial extends ScanHistoryState {}
class ScanHistoryLoading extends ScanHistoryState {}

class ScanHistoryLoaded extends ScanHistoryState {
  final List<ScanModel> scans;
  const ScanHistoryLoaded(this.scans);
  @override
  List<Object?> get props => [scans];
}

class ScanHistoryError extends ScanHistoryState {
  final String message;
  const ScanHistoryError(this.message);
  @override
  List<Object?> get props => [message];
}
