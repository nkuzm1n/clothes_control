import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';

class StatusRepository implements IStatusRepository {
  final DatabaseHelper databaseHelper;

  StatusRepository({required this.databaseHelper});

  @override
  Future<List<Status>> getStatuses() async {
    final result = await databaseHelper.getStatuses();
    return result.map((item) => Status.fromMap(item)).toList();
  }

  @override
  Future<Status?> getStatusById(int id) async {
    final status = await databaseHelper.getStatus(id);
    return status.isNotEmpty ? Status.fromMap(status) : null;
  }

  @override
  Future<int> addStatus(String status) async {
    return await databaseHelper.insertStatus(status);
  }
}
