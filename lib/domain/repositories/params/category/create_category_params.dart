import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_category_params.freezed.dart';

@freezed
abstract class CreateCategoryParams with _$CreateCategoryParams {
  const factory CreateCategoryParams({
    required String name,
  }) = _CreateCategoryParams;
}
