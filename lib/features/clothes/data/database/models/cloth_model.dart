import 'package:freezed_annotation/freezed_annotation.dart';

part 'cloth_model.freezed.dart';
part 'cloth_model.g.dart';

@freezed
abstract class ClothModel with _$ClothModel {
  const factory ClothModel({
    @JsonKey(includeIfNull: false) int? id,
    required String name,
    String? description,
    @JsonKey(name: 'status_id') int? statusId,
    @JsonKey(name: 'category_id') int? categoryId,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _ClothModel;

  factory ClothModel.fromJson(Map<String, Object?> json) => _$ClothModelFromJson(json);
}
