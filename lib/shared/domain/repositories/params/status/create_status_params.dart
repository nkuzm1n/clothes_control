import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_status_params.freezed.dart';

@freezed
abstract class CreateStatusParams with _$CreateStatusParams {
  const factory CreateStatusParams({
    required String name,
    required String color,
  }) = _CreateStatusParams;
}
