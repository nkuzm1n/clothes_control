import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_status_dto.freezed.dart';
part 'new_status_dto.g.dart';

@freezed
abstract class NewStatusDto with _$NewStatusDto {
  const factory NewStatusDto({
    required String name,
    required String color,
  }) = _NewStatusDto;

  factory NewStatusDto.fromJson(Map<String, Object?> json) => _$NewStatusDtoFromJson(json);
}
