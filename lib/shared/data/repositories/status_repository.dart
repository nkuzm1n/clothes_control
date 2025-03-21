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
  Future<void> addStatus(String status) async {
    await databaseHelper.insertStatus(status);
  }
}
