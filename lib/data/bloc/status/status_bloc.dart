import 'package:clothes_control/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/data/dto/status/status_dto.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';
import 'package:equatable/equatable.dart';

part 'status_event.dart';
part 'status_state.dart';

class StatusBloc extends Bloc<StatusEvent, StatusState> {
  late final IStatusRepository _statusRepository;

  StatusBloc({required IStatusRepository statusRepository}) : super(const StatusState()) {
    _statusRepository = statusRepository;

    on<LoadStatusListEvent>((event, emit) async {
      emit(LoadingStatusListState(list: state.list));
      try {
        final list = await _statusRepository.getManyBy();
        emit(LoadedStatusListState(list: list));
      } catch (e) {
        emit(StatusErrorState(error: e));
      }
    });

    on<DeleteStatusFromListEvent>((event, emit) async {
      emit(LoadingStatusListState(list: state.list));
      try {
        await _statusRepository.deleteOne(event.status);
        add(LoadStatusListEvent());
      } catch (e) {
        emit(StatusErrorState(error: e));
      }
    });

    on<LoadStatusEvent>((event, emit) async {
      emit(LoadingStatusState(status: event.status));
      try {
        final status = await _statusRepository.getOneById(event.status.id);
        emit(LoadedStatusState(status: status));
      } catch (e) {
        emit(StatusErrorState(error: e));
      }
    });

    on<UpdateStatusEvent>((event, emit) async {
      emit(LoadingStatusState(status: event.status));
      try {
        await _statusRepository.updateOne(event.status);
        emit(UpdatedStatusState(status: event.status));
      } catch (e) {
        emit(StatusErrorState(error: e));
      }
    });

    on<AddNewStatusEvent>((event, emit) async {
      emit(LoadingStatusState(newStatus: event.newStatus));
      try {
        final status = await _statusRepository.createOne(event.newStatus);
        emit(CreatedStatusState(status: status));
      } catch (e) {
        emit(StatusErrorState(error: e));
      }
    });
  }
}
