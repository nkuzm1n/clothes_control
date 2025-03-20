import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/repositories/clothes_repository.dart';

part 'clothes_list_event.dart';
part 'clothes_list_state.dart';

class ClothesListBloc extends Bloc<ClothesListEvent, ClothesListState> {
  final IClothesRepository clothesRepository;

  ClothesListBloc({required this.clothesRepository}) : super(ClothesListInitial()) {
    on<LoadClothesList>((event, emit) async {
      emit(ClothesListLoading());
      try {
        final clothesList = await clothesRepository.getClothesList();
        emit(ClothesListLoaded(clothesList: clothesList));
      } catch (e) {
        emit(ClothesListError(message: e.toString()));
      }
    });

    on<DeleteClothesItem>((event, emit) async {
      try {
        await clothesRepository.deleteClothesItem(event.itemId);
        emit(ClothesItemDeleted(itemId: event.itemId));
        // После удаления перезагружаем список
        add(const LoadClothesList());
      } catch (e) {
        emit(ClothesListError(message: e.toString()));
      }
    });
  }
}
