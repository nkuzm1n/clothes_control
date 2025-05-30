part of 'clothes_detail_bloc.dart';

abstract class ClothesDetailEvent extends Equatable {
  const ClothesDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothesDetail extends ClothesDetailEvent {
  final int? itemId;
  final ClothDTO? cloth;
  final List<StatusDTO>? statuses;

  const LoadClothesDetail({
    this.itemId,
    this.cloth,
    this.statuses,
  });

  @override
  List<Object?> get props => [itemId, cloth, statuses];
}

class UpdateClothesDetail extends ClothesDetailEvent {
  final ClothDTO cloth;

  final List<StatusDTO>? statuses;

  const UpdateClothesDetail({
    required this.cloth,
    this.statuses,
  });

  @override
  List<Object?> get props => [cloth, statuses];
}

class AddNewCloth extends ClothesDetailEvent {
  final NewClothDTO cloth;

  final List<StatusDTO>? statuses;

  const AddNewCloth({
    required this.cloth,
    this.statuses,
  });

  @override
  List<Object?> get props => [cloth, statuses];
}

class DeleteClothesItem extends ClothesDetailEvent {
  final ClothDTO cloth;

  final List<StatusDTO>? statuses;

  const DeleteClothesItem({
    required this.cloth,
    this.statuses,
  });

  @override
  List<Object?> get props => [cloth, statuses];
}

// class AddStatus extends ClothesDetailEvent {
//   final NewStatusDTO status;

//   const AddStatus({required this.status});
// }
