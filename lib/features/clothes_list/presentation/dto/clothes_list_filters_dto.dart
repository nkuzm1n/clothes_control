import 'package:equatable/equatable.dart';

class ClothesListFiltersDTO extends Equatable {
  final String? search;
  final int? statusId;
  final int? categoryId;

  const ClothesListFiltersDTO({this.search, this.statusId, this.categoryId});

  @override
  List<Object?> get props => [search, statusId, categoryId];
}
