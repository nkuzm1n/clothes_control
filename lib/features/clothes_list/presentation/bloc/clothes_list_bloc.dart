import 'package:clothes_control/features/clothes_list/data/dto/cloth_list_item_dto.dart';
import 'package:clothes_control/shared/domain/repositories/category_repository.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';
import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/shared/domain/repositories/clothes_repository.dart';

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
  }) : super(ClothesListInitial()) {
    on<LoadClothesListEvent>((event, emit) async {
      emit(ClothesListLoading());
      try {
        final clothes = await clothesRepository.getClothesList(name: event.search);
        final statusIds = clothes
            .where((cloth) => cloth.statusId != null)
            .map((cloth) => cloth.statusId!)
            .toList();
        final statuses = await statusRepository.getStatuses(id: statusIds);
        final categoryIds = clothes
            .where((cloth) => cloth.categoryId != null)
            .map((cloth) => cloth.categoryId!)
            .toList();
        final categories = await categoryRepository.getCategories(id: categoryIds);
        final list = clothes.map((cloth) {
          final status = statuses.firstWhereOrNull((s) => s.id == cloth.statusId);
          final category = categories.firstWhereOrNull((cat) => cat.id == cloth.categoryId);
          return ClothListItemDTO(cloth: cloth, status: status, category: category);
        });
        emit(ClothesListLoaded(clothesList: list.toList(), searchString: event.search));
      } catch (e) {
        emit(ClothesListError(message: e.toString()));
      }
    });

    on<DeleteClothesItemEvent>((event, emit) async {
      try {
        await clothesRepository.deleteCloth(event.itemId);
        emit(ClothesItemDeleted(itemId: event.itemId));
        add(const LoadClothesListEvent());
      } catch (e) {
        emit(ClothesListError(message: e.toString()));
      }
    });
  }
}
