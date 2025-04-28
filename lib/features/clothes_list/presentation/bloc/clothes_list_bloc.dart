import 'package:clothes_control/features/clothes_list/data/dto/cloth_list_item_dto.dart';
import 'package:clothes_control/shared/domain/repositories/condition_repository.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/repositories/clothes_repository.dart';

part 'clothes_list_event.dart';
part 'clothes_list_state.dart';

class ClothesListBloc extends Bloc<ClothesListEvent, ClothesListState> {
  final IClothesRepository clothesRepository;
  final IStatusRepository statusRepository;
  final IConditionRepository conditionRepository;

  ClothesListBloc({
    required this.clothesRepository,
    required this.statusRepository,
    required this.conditionRepository,
  }) : super(ClothesListInitial()) {
    on<LoadClothesList>((event, emit) async {
      emit(ClothesListLoading());
      try {
        final clothes = await clothesRepository.getClothesList();
        // TODO: get statuses and conditions in one query
        final list = <ClothListItemDTO>[];
        for (final cloth in clothes) {
          final status =
              cloth.statusId != null ? await statusRepository.getStatusById(cloth.statusId!) : null;
          final condition = cloth.conditionId != null
              ? await conditionRepository.getConditionById(cloth.conditionId!)
              : null;
          list.add(ClothListItemDTO(cloth: cloth, status: status, condition: condition));
        }
        emit(ClothesListLoaded(clothesList: list.toList()));
      } catch (e) {
        emit(ClothesListError(message: e.toString()));
      }
    });

    on<DeleteClothesItem>((event, emit) async {
      try {
        await clothesRepository.deleteCloth(event.itemId);
        emit(ClothesItemDeleted(itemId: event.itemId));
        add(const LoadClothesList());
      } catch (e) {
        emit(ClothesListError(message: e.toString()));
      }
    });
  }
}
