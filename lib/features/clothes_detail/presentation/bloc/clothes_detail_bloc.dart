import 'package:clothes_control/shared/data/dto/condition/new_condition_dto.dart';
import 'package:clothes_control/shared/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:clothes_control/shared/domain/repositories/condition_repository.dart';
import 'package:clothes_control/shared/domain/repositories/image_repository.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/repositories/clothes_repository.dart';

part 'clothes_detail_event.dart';
part 'clothes_detail_state.dart';

class ClothesDetailBloc extends Bloc<ClothesDetailEvent, ClothesDetailState> {
  final IClothesRepository clothesRepository;
  final IImageRepository imageRepository;
  final IStatusRepository statusRepository;
  final IConditionRepository conditionRepository;

  ClothesDetailBloc({
    required this.clothesRepository,
    required this.imageRepository,
    required this.statusRepository,
    required this.conditionRepository,
  }) : super(ClothesDetailInitial()) {
    on<LoadClothesDetail>((event, emit) async {
      emit(ClothesDetailLoading(
        cloth: event.cloth,
        conditions: event.conditions,
        statuses: event.statuses,
      ));
      try {
        final cloth = await clothesRepository.getClothById(event.itemId);
        final statuses = await statusRepository.getStatuses();
        final conditions = await conditionRepository.getConditions();
        emit(ClothesDetailLoaded(cloth: cloth, statuses: statuses, conditions: conditions));
      } catch (e) {
        emit(ClothesDetailError(error: e, message: e.toString()));
      }
    });

    on<UpdateClothesItem>((event, emit) async {
      emit(ClothesDetailLoading(
        cloth: event.updatedItem,
        conditions: event.conditions,
        statuses: event.statuses,
      ));
      try {
        await clothesRepository.updateCloth(event.updatedItem);
        emit(ClothesItemUpdated(updatedCloth: event.updatedItem));
        add(LoadClothesDetail(
          itemId: event.updatedItem.id,
          cloth: event.updatedItem,
          conditions: event.conditions,
          statuses: event.statuses,
        ));
      } catch (e) {
        emit(ClothesDetailError(error: e, message: e.toString()));
      }
    });

    on<InitEmptyClothesDetail>((event, emit) async {
      emit(const ClothesDetailLoading());
      try {
        final statuses = await statusRepository.getStatuses();
        final conditions = await conditionRepository.getConditions();
        emit(EmptyClothesDetailLoaded(statuses: statuses, conditions: conditions));
      } catch (e) {
        emit(ClothesDetailError(error: e, message: e.toString()));
      }
    });

    on<AddNewCloth>((event, emit) async {
      emit(const ClothesDetailLoading());
      try {
        final id = await clothesRepository.addCloth(event.item);
        final cloth = await clothesRepository.getClothById(id);
        final statuses = await statusRepository.getStatuses();
        final conditions = await conditionRepository.getConditions();
        emit(ClothesDetailLoaded(cloth: cloth, statuses: statuses, conditions: conditions));
      } catch (e) {
        emit(ClothesDetailError(error: e, message: e.toString()));
      }
    });

    on<DeleteClothesItem>((event, emit) async {
      try {
        await clothesRepository.deleteCloth(event.itemId);
        emit(ClothesItemDeleted(itemId: event.itemId));
      } catch (e) {
        emit(ClothesDetailError(error: e, message: e.toString()));
      }
    });

    on<AddStatus>((event, emit) async {
      emit(const ClothesDetailLoading());
      try {
        await statusRepository.addStatus(event.status);
        final statuses = await statusRepository.getStatuses();
        emit(StatusesUpdated(statuses: statuses));
      } catch (e) {
        emit(ClothesDetailError(error: e, message: e.toString()));
      }
    });

    on<AddCondition>((event, emit) async {
      emit(const ClothesDetailLoading());
      try {
        await conditionRepository.addCondition(event.condition);
        final conditions = await conditionRepository.getConditions();
        emit(ConditionsUpdated(conditions: conditions));
      } catch (e) {
        emit(ClothesDetailError(error: e, message: e.toString()));
      }
    });
  }
}
