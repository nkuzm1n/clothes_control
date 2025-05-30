import 'package:clothes_control/shared/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/shared/data/dto/status/status_dto.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';

class StatusRepositoryImpl implements IStatusRepository {
  final DatabaseHelper databaseHelper;

  StatusRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<StatusDTO>> getStatuses() async {
    final result = await databaseHelper.getStatuses();
    return result.map((item) => StatusDTO.fromMap(item)).toList();
  }

  @override
  Future<StatusDTO?> getStatusById(int id) async {
    final status = await databaseHelper.getStatus(id);
    return status.isNotEmpty ? StatusDTO.fromMap(status) : null;
  }

  @override
  Future<int> addStatus(NewStatusDTO status) async {
    return await databaseHelper.insertStatus(status.toMap());
  }
}
