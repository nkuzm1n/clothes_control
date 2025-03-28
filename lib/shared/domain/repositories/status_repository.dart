import 'package:clothes_control/shared/domain/entities/status.dart';

abstract class IStatusRepository {
  Future<List<Status>> getStatuses();
  Future<Status?> getStatusById(int id);
  Future<void> addStatus(String status);
}
