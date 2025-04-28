part of 'clothes_detail_bloc.dart';

abstract class ClothesDetailEvent extends Equatable {
  const ClothesDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothesDetail extends ClothesDetailEvent {
  final int itemId;
  final Cloth? cloth;
  final List<Condition>? conditions;
  final List<Status>? statuses;

  const LoadClothesDetail({
    required this.itemId,
    this.cloth,
    this.conditions,
    this.statuses,
  });

  @override
  List<Object?> get props => [itemId, cloth, conditions, statuses];
}

class UpdateClothesItem extends ClothesDetailEvent {
  final Cloth updatedItem;
  final List<Condition>? conditions;
  final List<Status>? statuses;

  const UpdateClothesItem({
    required this.updatedItem,
    this.conditions,
    this.statuses,
  });

  @override
  List<Object?> get props => [updatedItem, conditions, statuses];
}

class InitEmptyClothesDetail extends ClothesDetailEvent {
  const InitEmptyClothesDetail();

  @override
  List<Object> get props => [];
}

class AddNewCloth extends ClothesDetailEvent {
  final NewClothDTO item;

  const AddNewCloth({required this.item});

  @override
  List<Object> get props => [item];
}

class DeleteClothesItem extends ClothesDetailEvent {
  final int itemId;

  const DeleteClothesItem({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class AddStatus extends ClothesDetailEvent {
  final NewStatusDTO status;

  const AddStatus({required this.status});
}

class AddCondition extends ClothesDetailEvent {
  final NewConditionDTO condition;

  const AddCondition({required this.condition});
}
