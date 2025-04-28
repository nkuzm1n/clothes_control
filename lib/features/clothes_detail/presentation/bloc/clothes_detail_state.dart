part of 'clothes_detail_bloc.dart';

abstract class ClothesDetailState extends Equatable {
  const ClothesDetailState();

  @override
  List<Object?> get props => [];
}

class ClothesDetailInitial extends ClothesDetailState {}

class ClothesDetailLoading extends ClothesDetailState {
  final Cloth? cloth;
  final List<Status>? statuses;
  final List<Condition>? conditions;

  const ClothesDetailLoading({
    this.cloth,
    this.statuses,
    this.conditions,
  });

  @override
  List<Object?> get props => [cloth, statuses, conditions];
}

class ClothesDetailLoaded extends ClothesDetailState {
  final Cloth cloth;
  final List<Status> statuses;
  final List<Condition> conditions;

  const ClothesDetailLoaded({
    required this.cloth,
    required this.statuses,
    required this.conditions,
  });

  @override
  List<Object> get props => [cloth, statuses, conditions];
}

class EmptyClothesDetailLoaded extends ClothesDetailState {
  final List<Status> statuses;
  final List<Condition> conditions;

  const EmptyClothesDetailLoaded({
    required this.statuses,
    required this.conditions,
  });

  @override
  List<Object> get props => [statuses, conditions];
}

class ClothesDetailError extends ClothesDetailState {
  final dynamic error;
  final String message;

  const ClothesDetailError({required this.error, required this.message});

  @override
  List<Object?> get props => [error, message];
}

class ClothesItemUpdated extends ClothesDetailState {
  final Cloth updatedCloth;

  const ClothesItemUpdated({required this.updatedCloth});

  @override
  List<Object> get props => [updatedCloth];
}

class StatusesUpdated extends ClothesDetailState {
  final List<Status> statuses;

  const StatusesUpdated({required this.statuses});
}

class ConditionsUpdated extends ClothesDetailState {
  final List<Condition> conditions;

  const ConditionsUpdated({required this.conditions});
}

class ClothesItemDeleted extends ClothesDetailState {
  final int itemId;

  const ClothesItemDeleted({required this.itemId});

  @override
  List<Object> get props => [itemId];
}
