part of 'clothes_detail_bloc.dart';

abstract class ClothesDetailState extends Equatable {
  const ClothesDetailState();

  @override
  List<Object> get props => [];
}

class ClothesDetailInitial extends ClothesDetailState {}

class ClothesDetailLoading extends ClothesDetailState {}

class ClothesDetailLoaded extends ClothesDetailState {
  final Cloth clothesItem;

  const ClothesDetailLoaded({required this.clothesItem});

  @override
  List<Object> get props => [clothesItem];
}

class ClothesDetailError extends ClothesDetailState {
  final String message;

  const ClothesDetailError({required this.message});

  @override
  List<Object> get props => [message];
}

class ClothesItemUpdated extends ClothesDetailState {
  final Cloth updatedItem;

  const ClothesItemUpdated({required this.updatedItem});

  @override
  List<Object> get props => [updatedItem];
}

class StatusesUpdated extends ClothesDetailState {
  final List<String> statuses;

  const StatusesUpdated({required this.statuses});
}

class ConditionsUpdated extends ClothesDetailState {
  final List<String> conditions;

  const ConditionsUpdated({required this.conditions});
}

class ClothesItemDeleted extends ClothesDetailState {
  final int itemId;

  const ClothesItemDeleted({required this.itemId});

  @override
  List<Object> get props => [itemId];
}
