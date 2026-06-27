part of 'status_bloc.dart';

class StatusState extends Equatable {
  final List<StatusDTO>? list;
  final StatusDTO? status;
  final NewStatusDTO? newStatus;
  final dynamic error;

  const StatusState({
    this.list,
    this.status,
    this.newStatus,
    this.error,
  });

  String? get statusName => newStatus?.name ?? status?.name;

  String? get statusColor => newStatus?.color ?? status?.color;

  @override
  List<Object?> get props => [list, status, newStatus, error];
}

class LoadingStatusListState extends StatusState {
  const LoadingStatusListState({super.list, super.error});
}

class LoadedStatusListState extends StatusState {
  @override
  final List<StatusDTO> list;

  const LoadedStatusListState({required this.list, super.error});
}

class LoadingStatusState extends StatusState {
  const LoadingStatusState({
    super.list,
    super.status,
    super.newStatus,
    super.error,
  });
}

class LoadedStatusState extends StatusState {
  const LoadedStatusState({super.status, super.error});
}

class CreatedStatusState extends StatusState {
  @override
  final StatusDTO status;

  const CreatedStatusState({required this.status});
}

class UpdatedStatusState extends StatusState {
  @override
  final StatusDTO status;

  const UpdatedStatusState({required this.status});
}

class StatusErrorState extends StatusState {
  @override
  final dynamic error;

  const StatusErrorState({
    super.list,
    super.status,
    super.newStatus,
    required this.error,
  });
}
