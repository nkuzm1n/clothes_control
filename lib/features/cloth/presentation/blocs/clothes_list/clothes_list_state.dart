part of 'clothes_list_bloc.dart';

class ClothesListState extends Equatable {
  final List<ClothListItemDTO> clothes;
  final List<StatusDTO> statuses;
  final List<CategoryDTO> categories;
  final ClothesListFiltersDTO filters;
  final bool loading;
  final String? error;

  const ClothesListState({
    this.clothes = const [],
    this.statuses = const [],
    this.categories = const [],
    this.filters = const ClothesListFiltersDTO(),
    this.loading = false,
    this.error,
  });

  int get filtersCount {
    return [filters.statusId, filters.categoryId].nonNulls.length;
  }

  @override
  List<Object?> get props => [clothes, statuses, categories, filters, loading, error];

  ClothesListState copyWith({
    final List<ClothListItemDTO>? clothes,
    final ClothesListFiltersDTO? filters,
    final List<StatusDTO>? statuses,
    final List<CategoryDTO>? categories,
    final bool? loading,
    final String? error,
  }) {
    return ClothesListState(
      clothes: clothes ?? this.clothes,
      statuses: statuses ?? this.statuses,
      categories: categories ?? this.categories,
      filters: filters ?? this.filters,
      loading: loading ?? this.loading,
      error: error ?? this.error,
    );
  }
}
