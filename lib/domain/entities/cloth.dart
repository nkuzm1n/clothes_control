import 'package:freezed_annotation/freezed_annotation.dart';

part 'cloth.freezed.dart';
part 'cloth.g.dart';

@freezed
abstract class Cloth with _$Cloth {
  const factory Cloth({
    required int id,
    required String name,
    String? description,
    @JsonKey(name: 'status_id') int? statusId,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _Cloth;

  factory Cloth.fromJson(Map<String, Object?> json) => _$ClothFromJson(json);
}
