part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final List<Category>? list;
  final Category? category;
  final CreateCategoryParams? newCategory;
  final dynamic error;

  const CategoryState({
    this.list,
    this.category,
    this.newCategory,
    this.error,
  });

  String? get categoryName => newCategory?.name ?? category?.name;

  @override
  List<Object?> get props => [list, category, newCategory, error];
}

class LoadingCategoryListState extends CategoryState {
  const LoadingCategoryListState({super.list, super.error});
}

class LoadedCategoryListState extends CategoryState {
  @override
  final List<Category> list;

  const LoadedCategoryListState({required this.list, super.error});
}

class LoadingCategoryState extends CategoryState {
  const LoadingCategoryState({
    super.list,
    super.category,
    super.newCategory,
    super.error,
  });
}

class LoadedCategoryState extends CategoryState {
  const LoadedCategoryState({super.category, super.error});
}

class CreatedCategoryState extends CategoryState {
  @override
  final Category category;

  const CreatedCategoryState({required this.category});
}

class UpdatedCategoryState extends CategoryState {
  @override
  final Category category;

  const UpdatedCategoryState({required this.category});
}

class CategoryErrorState extends CategoryState {
  @override
  final dynamic error;

  const CategoryErrorState({
    super.list,
    super.category,
    super.newCategory,
    required this.error,
  });
}
