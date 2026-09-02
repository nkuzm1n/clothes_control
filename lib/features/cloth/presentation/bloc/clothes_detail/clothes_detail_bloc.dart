import 'package:clothes_control/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/domain/entities/category.dart';
import 'package:clothes_control/domain/entities/cloth.dart';
import 'package:clothes_control/domain/entities/status.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';
import 'package:clothes_control/domain/repositories/image_repository.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/domain/repositories/clothes_repository.dart';

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
        cloth: state.cloth,
        statuses: event.statuses,
        categories: event.categories,
      ));
      try {
        final cloth = event.id != null ? await clothesRepository.getOneById(event.id!) : null;
        final statuses = await statusRepository.getManyBy();
        final categories = await categoryRepository.getManyBy();
        emit(
          ClothesDetailLoadedState(cloth: cloth, statuses: statuses, categories: categories),
        );
      } catch (e) {
        emit(ClothesDetailErrorState(
          error: e,
          cloth: state.cloth,
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
        await clothesRepository.updateOne(event.cloth);
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
        final id = await clothesRepository.createOne(event.newCloth);
        final cloth = await clothesRepository.getOneById(id);
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
        cloth: state.cloth,
        statuses: event.statuses,
        categories: event.categories,
      ));
      try {
        await clothesRepository.deleteOne(event.id);
        emit(ClothesDetailDeletedState(
          statuses: event.statuses,
          categories: event.categories,
        ));
      } catch (e) {
        emit(ClothesDetailErrorState(
          error: e,
          cloth: state.cloth,
          statuses: event.statuses,
          categories: event.categories,
        ));
      }
    });
  }
}
