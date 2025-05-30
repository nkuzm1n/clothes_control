part of 'clothes_detail_bloc.dart';

abstract class ClothesDetailState extends Equatable {
  const ClothesDetailState();

  @override
  List<Object?> get props => [];
}

class ClothesDetailInitial extends ClothesDetailState {}

class ClothesDetailLoading extends ClothesDetailState {
  final ClothDTO? cloth;
  final NewClothDTO? newCloth;
  final List<StatusDTO>? statuses;

  const ClothesDetailLoading({
    this.cloth,
    this.newCloth,
    this.statuses,
  });

  @override
  List<Object?> get props => [cloth, newCloth, statuses];
}

class ClothesDetailLoaded extends ClothesDetailState {
  final ClothDTO? cloth;
  final List<StatusDTO> statuses;

  const ClothesDetailLoaded({this.cloth, required this.statuses});

  @override
  List<Object?> get props => [cloth, statuses];
}

class ClothesDetailUpdated extends ClothesDetailState {
  final ClothDTO cloth;
  final List<StatusDTO> statuses;

  const ClothesDetailUpdated({
    required this.cloth,
    required this.statuses,
  });

  @override
  List<Object?> get props => [cloth, statuses];
}

class ClothesDetailAdded extends ClothesDetailState {
  final ClothDTO cloth;
  final List<StatusDTO> statuses;

  const ClothesDetailAdded({
    required this.cloth,
    required this.statuses,
  });

  @override
  List<Object?> get props => [cloth, statuses];
}

class ClothesDetailDeleted extends ClothesDetailState {
  final ClothDTO? cloth;
  final List<StatusDTO> statuses;

  const ClothesDetailDeleted({
    this.cloth,
    required this.statuses,
  });

  @override
  List<Object?> get props => [cloth, statuses];
}

// class StatusesUpdated extends ClothesDetailState {
//   final List<StatusDTO> statuses;

//   const StatusesUpdated({required this.statuses});
// }

class ClothesDetailError extends ClothesDetailState {
  final dynamic error;
  final String message;
  final ClothDTO? cloth;
  final List<StatusDTO>? statuses;

  const ClothesDetailError({
    required this.error,
    required this.message,
    this.cloth,
    this.statuses,
  });

  @override
  List<Object?> get props => [error, message, cloth, statuses];
}
