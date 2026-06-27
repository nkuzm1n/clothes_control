import 'package:clothes_control/core/data/dto/category/category_dto.dart';
import 'package:clothes_control/core/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/core/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/core/data/dto/status/status_dto.dart';
import 'package:clothes_control/core/domain/repositories/category_repository.dart';
import 'package:clothes_control/core/domain/repositories/image_repository.dart';
import 'package:clothes_control/core/domain/repositories/status_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/core/domain/repositories/clothes_repository.dart';

part 'clothes_detail_event.dart';
part 'clothes_detail_state.dart';

class ClothesDetailBloc extends Bloc<ClothesDetailEvent, ClothesDetailState> {
  final IClothesRepository clothesRepository;
  final IImageRepository imageRepository;
  final IStatusRepository statusRepository;
  final ICategoryRepository categoryRepository;

  ClothesDetailBloc({
    required this.clothesRepository,
    required this.imageRepository,
    required this.statusRepository,
    required this.categoryRepository,
  }) : super(const ClothesDetailState()) {
    on<LoadClothesDetailEvent>((event, emit) async {
      emit(ClothesDetailLoadingState(
        cloth: event.cloth,
        statuses: event.statuses,
        categories: event.categories,
      ));
      try {
        final cloth =
            event.cloth != null ? await clothesRepository.getClothById(event.cloth!.id) : null;
        final statuses = await statusRepository.getStatuses();
        final categories = await categoryRepository.getCategories();
        emit(
          ClothesDetailLoadedState(cloth: cloth, statuses: statuses, categories: categories),
        );
      } catch (e) {
        emit(ClothesDetailErrorState(
          error: e,
          cloth: event.cloth,
          statuses: event.statuses,
          categories: event.categories,
        ));
      }
    });

    on<UpdateClothesDetailEvent>((event, emit) async {
      emit(ClothesDetailLoadingState(
        cloth: event.cloth,
        statuses: event.statuses,
        categories: event.categories,
      ));
      try {
        await clothesRepository.updateCloth(event.cloth);
        emit(ClothesDetailUpdatedState(
          cloth: event.cloth,
          statuses: event.statuses,
          categories: event.categories,
        ));
      } catch (e) {
        emit(ClothesDetailErrorState(
          error: e,
          cloth: event.cloth,
          statuses: event.statuses,
          categories: event.categories,
        ));
      }
    });

    on<AddNewClothEvent>((event, emit) async {
      emit(ClothesDetailLoadingState(
        newCloth: event.newCloth,
        statuses: event.statuses,
        categories: event.categories,
      ));
      try {
        print("new cloth ${event.newCloth}");
        final id = await clothesRepository.addCloth(event.newCloth);
        final cloth = await clothesRepository.getClothById(id);
        emit(ClothesDetailAddedState(
          cloth: cloth!,
          statuses: event.statuses,
          categories: event.categories,
        ));
      } catch (e) {
        emit(ClothesDetailErrorState(
          error: e,
          newCloth: event.newCloth,
          statuses: event.statuses,
          categories: event.categories,
        ));
      }
    });

    on<DeleteClothesItemEvent>((event, emit) async {
      emit(ClothesDetailLoadingState(
        cloth: event.cloth,
        statuses: event.statuses,
        categories: event.categories,
      ));
      try {
        await clothesRepository.deleteCloth(event.cloth.id);
        emit(ClothesDetailDeletedState(
          statuses: event.statuses,
          categories: event.categories,
        ));
      } catch (e) {
        emit(ClothesDetailErrorState(
          error: e,
          cloth: event.cloth,
          statuses: event.statuses,
          categories: event.categories,
        ));
      }
    });
  }
}
