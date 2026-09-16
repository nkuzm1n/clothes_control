import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required String name,
    String? createdAt,
    String? updatedAt,
  }) = _Category;
}
