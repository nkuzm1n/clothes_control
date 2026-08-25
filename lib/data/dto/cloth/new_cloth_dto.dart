import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_cloth_dto.freezed.dart';
part 'new_cloth_dto.g.dart';

@freezed
abstract class NewClothDto with _$NewClothDto {
  const factory NewClothDto({
    required String name,
    String? description,
    @JsonKey(name: 'status_id') int? statusId,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _NewClothDto;

  factory NewClothDto.fromJson(Map<String, Object?> json) => _$NewClothDtoFromJson(json);
}
