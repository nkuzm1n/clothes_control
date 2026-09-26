import 'package:freezed_annotation/freezed_annotation.dart';

part 'cloth.freezed.dart';

@freezed
abstract class Cloth with _$Cloth {
  const factory Cloth({
    required int id,
    required String name,
    String? description,
    int? statusId,
    int? categoryId,
    String? imageUrl,
    String? createdAt,
    String? updatedAt,
  }) = _Cloth;
}
