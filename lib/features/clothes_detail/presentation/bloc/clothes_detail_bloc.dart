import 'package:clothes_control/shared/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/status/status_dto.dart';
import 'package:clothes_control/shared/domain/repositories/image_repository.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/shared/domain/repositories/clothes_repository.dart';

part 'clothes_detail_event.dart';
part 'clothes_detail_state.dart';

class ClothesDetailBloc extends Bloc<ClothesDetailEvent, ClothesDetailState> {
  final IClothesRepository clothesRepository;
  final IImageRepository imageRepository;
  final IStatusRepository statusRepository;

  ClothesDetailBloc({
    required this.clothesRepository,
    required this.imageRepository,
    required this.statusRepository,
  }) : super(ClothesDetailInitial()) {
    on<LoadClothesDetail>((event, emit) async {
      emit(ClothesDetailLoading(
        cloth: event.cloth,
        statuses: event.statuses,
      ));
      try {
        final cloth =
            event.itemId != null ? await clothesRepository.getClothById(event.itemId!) : null;
        final statuses = await statusRepository.getStatuses();
        emit(ClothesDetailLoaded(cloth: cloth, statuses: statuses));
      } catch (e) {
        emit(ClothesDetailError(
          error: e,
          message: e.toString(),
          cloth: event.cloth,
          statuses: event.statuses,
        ));
      }
    });

    on<UpdateClothesDetail>((event, emit) async {
      emit(ClothesDetailLoading(
        cloth: event.cloth,
        statuses: event.statuses,
      ));
      try {
        await clothesRepository.updateCloth(event.cloth);
        emit(ClothesDetailUpdated(
          cloth: event.cloth,
          statuses: event.statuses!,
        ));
      } catch (e) {
        emit(ClothesDetailError(
          error: e,
          message: e.toString(),
          cloth: event.cloth,
          statuses: event.statuses,
        ));
      }
    });

    on<AddNewCloth>((event, emit) async {
      emit(ClothesDetailLoading(
        newCloth: event.cloth,
        statuses: event.statuses,
      ));
      try {
        final id = await clothesRepository.addCloth(event.cloth);
        final cloth = await clothesRepository.getClothById(id);
        final statuses = await statusRepository.getStatuses();
        emit(ClothesDetailAdded(
          cloth: cloth!,
          statuses: statuses,
        ));
      } catch (e) {
        emit(ClothesDetailError(
          error: e,
          message: e.toString(),
          statuses: event.statuses,
        ));
      }
    });

    on<DeleteClothesItem>((event, emit) async {
      emit(ClothesDetailLoading(
        cloth: event.cloth,
        statuses: event.statuses,
      ));
      try {
        await clothesRepository.deleteCloth(event.cloth.id);
        emit(ClothesDetailDeleted(
          cloth: null,
          statuses: event.statuses!,
        ));
      } catch (e) {
        emit(ClothesDetailError(
          error: e,
          message: e.toString(),
          cloth: event.cloth,
          statuses: event.statuses,
        ));
      }
    });

    // on<AddStatus>((event, emit) async {
    //   emit(const ClothesDetailLoading());
    //   try {
    //     await statusRepository.addStatus(event.status);
    //     final statuses = await statusRepository.getStatuses();
    //     emit(StatusesUpdated(statuses: statuses));
    //   } catch (e) {
    //     emit(ClothesDetailError(
    //       error: e,
    //       message: e.toString(),
    //       cloth: event.cloth,
    //       statuses: event.statuses,
    //           //     ));
    //   }
    // });

    //   }
    // });
  }
}
