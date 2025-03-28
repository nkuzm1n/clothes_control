part of 'clothes_detail_bloc.dart';

abstract class ClothesDetailEvent extends Equatable {
  const ClothesDetailEvent();

  @override
  List<Object> get props => [];
}

class LoadClothesDetail extends ClothesDetailEvent {
  final int itemId;

  const LoadClothesDetail({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class UpdateClothesItem extends ClothesDetailEvent {
  final Cloth updatedItem;

  const UpdateClothesItem({required this.updatedItem});

  @override
  List<Object> get props => [updatedItem];
}

class LoadNewClothesDetailParams extends ClothesDetailEvent {
  const LoadNewClothesDetailParams();

  @override
  List<Object> get props => [];
}

class AddNewClothesItem extends ClothesDetailEvent {
  final NewClothDTO item;

  const AddNewClothesItem({required this.item});

  @override
  List<Object> get props => [item];
}

class DeleteClothesItem extends ClothesDetailEvent {
  final int itemId;

  const DeleteClothesItem({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class AddClothesItemImage extends ClothesDetailEvent {
  final Cloth clothesItem;
  final File imageFile;

  const AddClothesItemImage({required this.clothesItem, required this.imageFile});

  @override
  List<Object> get props => [clothesItem, imageFile];
}

class AddStatus extends ClothesDetailEvent {
  final String status;

  const AddStatus({required this.status});
}

class AddCondition extends ClothesDetailEvent {
  final String condition;

  const AddCondition({required this.condition});
}
