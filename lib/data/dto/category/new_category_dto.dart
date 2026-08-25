import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_category_dto.freezed.dart';
part 'new_category_dto.g.dart';

@freezed
abstract class NewCategoryDto with _$NewCategoryDto {
  const factory NewCategoryDto({
    required String name,
  }) = _NewCategoryDto;

  factory NewCategoryDto.fromJson(Map<String, Object?> json) => _$NewCategoryDtoFromJson(json);
}
