import 'package:clothes_control/shared/domain/entities/category.dart';
import 'package:clothes_control/features/clothes/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:equatable/equatable.dart';

class ClothListItemDTO extends Equatable {
  final Cloth cloth;
  final Status? status;
  final Category? category;

  const ClothListItemDTO({
    required this.cloth,
    required this.status,
    required this.category,
  });

  @override
  List<Object?> get props => [cloth, status, category];
}
