import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_model.freezed.dart';
part 'category_model.g.dart';

@freezed
abstract class CategoryModel with _$CategoryModel {
  const factory CategoryModel({
    @JsonKey(includeIfNull: false) int? id,
    required String name,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _CategoryModel;

  factory CategoryModel.fromJson(Map<String, Object?> json) => _$CategoryModelFromJson(json);
}
