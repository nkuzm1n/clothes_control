import 'package:clothes_control/shared/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/shared/data/dto/status/status_dto.dart';

abstract class IStatusRepository {
  Future<List<StatusDTO>> getStatuses();
  Future<StatusDTO?> getStatusById(int id);
  Future<void> addStatus(NewStatusDTO status);
}
