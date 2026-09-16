import 'package:clothes_control/data/database/models/status_model.dart';
import 'package:clothes_control/domain/entities/status.dart';
import 'package:clothes_control/domain/repositories/params/status/create_status_params.dart';

class StatusMapper {
  static Status fromModel(StatusModel status) {
    return Status(
      id: status.id!,
      name: status.name,
      color: status.color,
      createdAt: status.createdAt,
      updatedAt: status.updatedAt,
    );
  }

  static StatusModel toModel(Status status) {
    return StatusModel(
      id: status.id,
      name: status.name,
      color: status.color,
      createdAt: status.createdAt,
      updatedAt: status.updatedAt,
    );
  }

  static StatusModel createParamsToModel(CreateStatusParams createParams) {
    return StatusModel(
      id: null,
      name: createParams.name,
      color: createParams.color,
    );
  }
}
