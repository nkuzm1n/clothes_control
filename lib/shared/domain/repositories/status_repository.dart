import 'package:clothes_control/shared/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';

abstract class IStatusRepository {
  Future<List<Status>> getStatuses();
  Future<Status?> getStatusById(int id);
  Future<void> addStatus(NewStatusDTO status);
}
