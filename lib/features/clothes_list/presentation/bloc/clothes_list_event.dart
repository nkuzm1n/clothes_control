part of 'clothes_list_bloc.dart';

abstract class ClothesListEvent extends Equatable {
  const ClothesListEvent();

  @override
  List<Object> get props => [];
}

class LoadClothesList extends ClothesListEvent {
  const LoadClothesList();
}

class DeleteClothesItem extends ClothesListEvent {
  final int itemId;

  const DeleteClothesItem({required this.itemId});

  @override
  List<Object> get props => [itemId];
}
