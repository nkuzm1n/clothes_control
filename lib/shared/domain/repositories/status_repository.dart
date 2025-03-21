import 'package:clothes_control/shared/domain/entities/status.dart';

abstract class IStatusRepository {
  Future<List<Status>> getStatuses();
  Future<void> addStatus(String status);
}
