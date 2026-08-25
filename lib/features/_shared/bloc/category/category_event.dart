part of 'category_bloc.dart';

sealed class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoryListEvent extends CategoryEvent {}

class DeleteCategoryFromListEvent extends CategoryEvent {
  final Category category;

  const DeleteCategoryFromListEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class LoadCategoryEvent extends CategoryEvent {
  final Category category;

  const LoadCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class UpdateCategoryEvent extends CategoryEvent {
  final Category category;

  const UpdateCategoryEvent({required this.category});

  @override
  List<Object> get props => [category];
}

class AddNewCategoryEvent extends CategoryEvent {
  final NewCategoryDto newCategory;

  const AddNewCategoryEvent({required this.newCategory});

  @override
  List<Object> get props => [newCategory];
}
