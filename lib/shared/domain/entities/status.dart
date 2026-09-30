import 'package:freezed_annotation/freezed_annotation.dart';

part 'status.freezed.dart';

@freezed
abstract class Status with _$Status {
  const factory Status({
    required int id,
    required String name,
    required String color,
    String? createdAt,
    String? updatedAt,
  }) = _Status;
}
