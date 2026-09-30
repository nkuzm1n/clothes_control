part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoryListEvent extends CategoryEvent {}

class DeleteCategoryFromListEvent extends CategoryEvent {
  final int id;

  const DeleteCategoryFromListEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class LoadCategoryEvent extends CategoryEvent {
  final int id;

  const LoadCategoryEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class UpdateCategoryEvent extends CategoryEvent {
  final Category category;

  const UpdateCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class AddNewCategoryEvent extends CategoryEvent {
  final CreateCategoryParams newCategory;

  const AddNewCategoryEvent({required this.newCategory});

  @override
  List<Object> get props => [newCategory];
}
