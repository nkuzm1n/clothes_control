part of 'status_bloc.dart';

sealed class StatusEvent extends Equatable {
  const StatusEvent();

  @override
  List<Object> get props => [];
}

class LoadStatusListEvent extends StatusEvent {}

class DeleteStatusFromListEvent extends StatusEvent {
  final int id;

  const DeleteStatusFromListEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class LoadStatusEvent extends StatusEvent {
  final int id;

  const LoadStatusEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateStatusEvent extends StatusEvent {
  final Status status;

  const UpdateStatusEvent({required this.status});

  @override
  List<Object> get props => [status];
}

class AddNewStatusEvent extends StatusEvent {
  final CreateStatusParams newStatus;

  const AddNewStatusEvent({required this.newStatus});

  @override
  List<Object> get props => [newStatus];
}
