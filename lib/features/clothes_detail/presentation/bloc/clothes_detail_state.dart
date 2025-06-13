part of 'clothes_detail_bloc.dart';

class ClothesDetailState extends Equatable {
  final ClothDTO? cloth;
  final NewClothDTO? newCloth;
  final List<StatusDTO> statuses;
  final List<CategoryDTO> categories;
  final dynamic error;

  const ClothesDetailState({
    this.cloth,
    this.newCloth,
    this.statuses = const [],
    this.categories = const [],
    this.error,
  });

  String? get clothName => newCloth?.name ?? cloth?.name;
  String? get clothDescription => newCloth?.description ?? cloth?.description;
  String? get clothImageUrl => newCloth?.imageUrl ?? cloth?.imageUrl;
  int? get clothCategoryId => newCloth?.categoryId ?? cloth?.categoryId;
  int? get clothStatusId => newCloth?.statusId ?? cloth?.statusId;

  @override
  List<Object?> get props => [cloth, newCloth, statuses, categories, error];
}

class ClothesDetailLoadingState extends ClothesDetailState {
  const ClothesDetailLoadingState({
    super.cloth,
    super.newCloth,
    super.statuses,
    super.categories,
  });
}

class ClothesDetailLoadedState extends ClothesDetailState {
  const ClothesDetailLoadedState({
    super.cloth,
    super.statuses,
    super.categories,
  });
}

class ClothesDetailUpdatedState extends ClothesDetailState {
  @override
  final ClothDTO cloth;

  const ClothesDetailUpdatedState({
    required this.cloth,
    super.statuses,
    super.categories,
  });
}

class ClothesDetailAddedState extends ClothesDetailState {
  @override
  final ClothDTO cloth;

  const ClothesDetailAddedState({
    required this.cloth,
    super.statuses,
    super.categories,
  });
}

class ClothesDetailDeletedState extends ClothesDetailState {
  const ClothesDetailDeletedState({
    super.statuses,
    super.categories,
  });
}

class ClothesDetailErrorState extends ClothesDetailState {
  const ClothesDetailErrorState({
    required super.error,
    super.cloth,
    super.newCloth,
    super.statuses,
    super.categories,
  });
}
