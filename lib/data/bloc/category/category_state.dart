part of 'category_bloc.dart';

class CategoryState extends Equatable {
  final List<CategoryDTO>? list;
  final CategoryDTO? category;
  final NewCategoryDTO? newCategory;
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
  final List<CategoryDTO> list;

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
  final CategoryDTO category;

  const CreatedCategoryState({required this.category});
}

class UpdatedCategoryState extends CategoryState {
  @override
  final CategoryDTO category;

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
