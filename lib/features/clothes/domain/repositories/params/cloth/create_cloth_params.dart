import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_cloth_params.freezed.dart';

@freezed
abstract class CreateClothParams with _$CreateClothParams {
  const factory CreateClothParams({
    required String name,
    String? description,
    int? statusId,
    int? categoryId,
    String? imageUrl,
  }) = _CreateClothParams;
}
