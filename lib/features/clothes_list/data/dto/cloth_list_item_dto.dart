import 'package:clothes_control/shared/data/dto/category/category_dto.dart';
import 'package:clothes_control/shared/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/status/status_dto.dart';
import 'package:equatable/equatable.dart';

class ClothListItemDTO extends Equatable {
  final ClothDTO cloth;
  final StatusDTO? status;
  final CategoryDTO? category;

  const ClothListItemDTO({
    required this.cloth,
    required this.status,
    required this.category,
  });

  @override
  List<Object?> get props => [cloth, status, category];
}
