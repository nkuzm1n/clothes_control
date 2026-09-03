import 'package:freezed_annotation/freezed_annotation.dart';

part 'status_model.freezed.dart';
part 'status_model.g.dart';

@freezed
abstract class StatusModel with _$StatusModel {
  const factory StatusModel({
    @JsonKey(includeIfNull: false) int? id,
    required String name,
    required String color,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _StatusModel;

  factory StatusModel.fromJson(Map<String, Object?> json) => _$StatusModelFromJson(json);
}
