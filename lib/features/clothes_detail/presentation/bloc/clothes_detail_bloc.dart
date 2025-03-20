import 'dart:io';

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
      emit(ClothesDetailLoading());
      try {
        final clothesItem = await clothesRepository.getClothesItemById(event.itemId);
        emit(ClothesDetailLoaded(clothesItem: clothesItem));
      } catch (e) {
        emit(ClothesDetailError(message: e.toString()));
      }
    });

    on<UpdateClothesItem>((event, emit) async {
      emit(ClothesDetailLoading());
      try {
        await clothesRepository.updateClothesItem(event.updatedItem);
        emit(ClothesItemUpdated(updatedItem: event.updatedItem));
      } catch (e) {
        emit(ClothesDetailError(message: e.toString()));
      }
    });

    on<DeleteClothesItem>((event, emit) async {
      try {
        await clothesRepository.deleteClothesItem(event.itemId);
        emit(ClothesItemDeleted(itemId: event.itemId));
      } catch (e) {
        emit(ClothesDetailError(message: e.toString()));
      }
    });

    on<AddClothesItemImage>((event, emit) async {
      emit(ClothesDetailLoading());
      try {
        final imageFile = await imageRepository.saveImage(event.imageFile);
        final updatedItem = event.clothesItem.copyWith(imageUrl: imageFile.path);
        await clothesRepository.updateClothesItem(updatedItem);
        final clothesItem = await clothesRepository.getClothesItemById(event.clothesItem.id);
        emit(ClothesItemUpdated(updatedItem: clothesItem));
      } catch (e) {
        emit(ClothesDetailError(message: e.toString()));
      }
    });

    on<AddStatus>((event, emit) async {
      emit(ClothesDetailLoading());
      try {
        await statusRepository.addStatus(event.status);
        final statuses = await statusRepository.getStatuses();
        emit(StatusesUpdated(statuses: statuses));
      } catch (e) {
        emit(ClothesDetailError(message: e.toString()));
      }
    });

    on<AddCondition>((event, emit) async {
      emit(ClothesDetailLoading());
      try {
        await conditionRepository.addCondition(event.condition);
        final conditions = await conditionRepository.getConditions();
        emit(ConditionsUpdated(conditions: conditions));
      } catch (e) {
        emit(ClothesDetailError(message: e.toString()));
      }
    });
  }
}
