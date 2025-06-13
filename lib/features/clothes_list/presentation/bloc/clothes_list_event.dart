part of 'clothes_list_bloc.dart';

abstract class ClothesListEvent extends Equatable {
  const ClothesListEvent();

  @override
  List<Object?> get props => [];
}

class LoadClothesListEvent extends ClothesListEvent {
  final String? search;

  const LoadClothesListEvent({this.search});

  @override
  List<Object?> get props => [search];
}

class DeleteClothesItemEvent extends ClothesListEvent {
  final int itemId;

  const DeleteClothesItemEvent({required this.itemId});

  @override
  List<Object> get props => [itemId];
}
