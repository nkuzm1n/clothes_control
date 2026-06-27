import 'package:clothes_control/features/cloth/data/dto/cloth_list_item_dto.dart';
import 'package:clothes_control/features/cloth/presentation/dto/clothes_list_filters_dto.dart';
import 'package:clothes_control/core/data/dto/category/category_dto.dart';
import 'package:clothes_control/core/data/dto/status/status_dto.dart';
import 'package:clothes_control/core/domain/repositories/category_repository.dart';
import 'package:clothes_control/core/domain/repositories/status_repository.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/core/domain/repositories/clothes_repository.dart';

part 'clothes_list_event.dart';
part 'clothes_list_state.dart';

class ClothesListBloc extends Bloc<ClothesListEvent, ClothesListState> {
  final IClothesRepository clothesRepository;
  final IStatusRepository statusRepository;
  final ICategoryRepository categoryRepository;

  ClothesListBloc({
    required this.clothesRepository,
    required this.statusRepository,
    required this.categoryRepository,
  }) : super(const ClothesListState()) {
    on<LoadClothesListEvent>((event, emit) async {
      emit(state.copyWith(filters: event.filters, loading: true));
      try {
        final statuses = await statusRepository.getStatuses();
        final categories = await categoryRepository.getCategories();
        final clothes = await clothesRepository.getClothesList(
          name: event.filters.search,
          statusId: event.filters.statusId,
          categoryId: event.filters.categoryId,
        );
        final list = clothes.map((cloth) {
          final status = statuses.firstWhereOrNull((s) => s.id == cloth.statusId);
          final category = categories.firstWhereOrNull((cat) => cat.id == cloth.categoryId);
          return ClothListItemDTO(cloth: cloth, status: status, category: category);
        });
        emit(state.copyWith(
          clothes: list.toList(),
          statuses: statuses,
          categories: categories,
          loading: false,
        ));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), loading: false));
      }
    });

    on<DeleteClothesItemEvent>((event, emit) async {
      emit(state.copyWith(loading: true));
      try {
        await clothesRepository.deleteCloth(event.itemId);
        add(const LoadClothesListEvent());
      } catch (e) {
        emit(state.copyWith(error: e.toString(), loading: false));
      }
    });
  }
}
