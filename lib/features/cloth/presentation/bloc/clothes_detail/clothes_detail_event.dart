part of 'clothes_detail_bloc.dart';

abstract class ClothesDetailEvent extends Equatable {
  const ClothesDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothesDetailEvent extends ClothesDetailEvent {
  final int? id;
  final List<Status> statuses;
  final List<Category> categories;

  const LoadClothesDetailEvent({
    this.id,
    required this.statuses,
    required this.categories,
  });

  @override
  List<Object?> get props => [id, statuses, categories];
}

class UpdateClothesDetailEvent extends ClothesDetailEvent {
  final Cloth cloth;
  final List<Status> statuses;
  final List<Category> categories;

  const UpdateClothesDetailEvent({
    required this.cloth,
    required this.statuses,
    required this.categories,
  });

  @override
  List<Object> get props => [cloth, statuses, categories];
}

class AddNewClothEvent extends ClothesDetailEvent {
  final NewClothDto newCloth;
  final List<Status> statuses;
  final List<Category> categories;

  const AddNewClothEvent({
    required this.newCloth,
    required this.statuses,
    required this.categories,
  });

  @override
  List<Object?> get props => [newCloth, statuses, categories];
}

class DeleteClothesItemEvent extends ClothesDetailEvent {
  final int id;
  final List<Status> statuses;
  final List<Category> categories;

  const DeleteClothesItemEvent({
    required this.id,
    required this.statuses,
    required this.categories,
  });

  @override
  List<Object?> get props => [id, statuses, categories];
}
