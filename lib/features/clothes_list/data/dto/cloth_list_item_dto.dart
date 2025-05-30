import 'package:clothes_control/shared/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/status/status_dto.dart';
import 'package:equatable/equatable.dart';

class ClothListItemDTO extends Equatable {
  final ClothDTO cloth;
  final StatusDTO? status;

  const ClothListItemDTO({
    required this.cloth,
    required this.status,
  });

  @override
  List<Object?> get props => [cloth, status];
}
