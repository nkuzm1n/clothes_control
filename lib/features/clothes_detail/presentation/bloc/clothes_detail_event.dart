part of 'clothes_detail_bloc.dart';

abstract class ClothesDetailEvent extends Equatable {
  const ClothesDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothesDetailEvent extends ClothesDetailEvent {
  final ClothDTO? cloth;
  final List<StatusDTO> statuses;
  final List<CategoryDTO> categories;

  const LoadClothesDetailEvent({
    this.cloth,
    required this.statuses,
    required this.categories,
  });

  @override
  List<Object?> get props => [cloth, statuses, categories];
}

class UpdateClothesDetailEvent extends ClothesDetailEvent {
  final ClothDTO cloth;
  final List<StatusDTO> statuses;
  final List<CategoryDTO> categories;

  const UpdateClothesDetailEvent({
    required this.cloth,
    required this.statuses,
    required this.categories,
  });

  @override
  List<Object> get props => [cloth, statuses, categories];
}

class AddNewClothEvent extends ClothesDetailEvent {
  final NewClothDTO newCloth;
  final List<StatusDTO> statuses;
  final List<CategoryDTO> categories;

  const AddNewClothEvent({
    required this.newCloth,
    required this.statuses,
    required this.categories,
  });

  @override
  List<Object?> get props => [newCloth, statuses, categories];
}

class DeleteClothesItemEvent extends ClothesDetailEvent {
  final ClothDTO cloth;
  final List<StatusDTO> statuses;
  final List<CategoryDTO> categories;

  const DeleteClothesItemEvent({
    required this.cloth,
    required this.statuses,
    required this.categories,
  });

  @override
  List<Object?> get props => [cloth, statuses, categories];
}
