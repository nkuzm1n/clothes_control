import 'package:freezed_annotation/freezed_annotation.dart';

part 'status.freezed.dart';
part 'status.g.dart';

@freezed
abstract class Status with _$Status {
  const factory Status({
    required int id,
    required String name,
    required String color,
    @JsonKey(name: 'created_at') String? createdAt,
    @JsonKey(name: 'updated_at') String? updatedAt,
  }) = _Status;

  factory Status.fromJson(Map<String, Object?> json) => _$StatusFromJson(json);
}
