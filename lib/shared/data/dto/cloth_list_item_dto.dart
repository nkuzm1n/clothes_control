import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:equatable/equatable.dart';

class ClothListItemDTO extends Equatable {
  final Cloth cloth;
  final Status? status;
  final Condition? condition;

  const ClothListItemDTO({
    required this.cloth,
    required this.status,
    required this.condition,
  });

  @override
  List<Object?> get props => [cloth, status, condition];
}
