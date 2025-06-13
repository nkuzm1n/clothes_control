part of 'clothes_list_bloc.dart';

abstract class ClothesListState extends Equatable {
  const ClothesListState();

  @override
  List<Object?> get props => [];
}

class ClothesListInitial extends ClothesListState {}

class ClothesListLoading extends ClothesListState {}

class ClothesListLoaded extends ClothesListState {
  final List<ClothListItemDTO> clothesList;
  final String? searchString;

  const ClothesListLoaded({required this.clothesList, this.searchString});

  @override
  List<Object?> get props => [clothesList, searchString];
}

class ClothesItemDeleted extends ClothesListState {
  final int itemId;

  const ClothesItemDeleted({required this.itemId});

  @override
  List<Object> get props => [itemId];
}

class ClothesListError extends ClothesListState {
  final String message;

  const ClothesListError({required this.message});

  @override
  List<Object> get props => [message];
}
