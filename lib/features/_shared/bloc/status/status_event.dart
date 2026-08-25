part of 'status_bloc.dart';

sealed class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

class LoadStatusListEvent extends StatusEvent {}

class DeleteStatusFromListEvent extends StatusEvent {
  final Status status;

  const DeleteStatusFromListEvent({required this.status});

  @override
  List<Object> get props => [status];
}

class LoadStatusEvent extends StatusEvent {
  final Status status;

  const LoadStatusEvent({required this.status});

  @override
  List<Object> get props => [status];
}

class UpdateStatusEvent extends StatusEvent {
  final Status status;

  const UpdateStatusEvent({required this.status});

  @override
  List<Object> get props => [status];
}

class AddNewStatusEvent extends StatusEvent {
  final NewStatusDto newStatus;

  const AddNewStatusEvent({required this.newStatus});

  @override
  List<Object> get props => [newStatus];
}
