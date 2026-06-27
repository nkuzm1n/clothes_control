import 'package:clothes_control/core/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/core/data/dto/status/status_dto.dart';

abstract class IStatusRepository {
  Future<List<StatusDTO>> getStatuses({List<int>? id});
  Future<StatusDTO?> getStatusById(int id);
  Future<StatusDTO> addStatus(NewStatusDTO status);
  Future<int> updateStatus(StatusDTO status);
  Future<int> deleteStatus(StatusDTO status);
}
