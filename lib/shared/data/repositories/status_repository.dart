import 'package:clothes_control/shared/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/shared/data/dto/status/status_dto.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';

class StatusRepositoryImpl implements IStatusRepository {
  final DatabaseHelper databaseHelper;

  StatusRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<StatusDTO>> getStatuses({List<int>? id}) async {
    final result = await databaseHelper.getStatuses(id: id);
    return result.map((item) => StatusDTO.fromMap(item)).toList();
  }

  @override
  Future<StatusDTO?> getStatusById(int id) async {
    final result = await databaseHelper.getStatus(id);
    return result.isNotEmpty ? StatusDTO.fromMap(result) : null;
  }

  @override
  Future<StatusDTO> addStatus(NewStatusDTO status) async {
    final id = await databaseHelper.insertStatus(status.toMap());
    final result = await getStatusById(id);
    return result!;
  }

  @override
  Future<int> updateStatus(StatusDTO status) async {
    return await databaseHelper.updateStatus(status.toMap());
  }

  @override
  Future<int> deleteStatus(StatusDTO status) async {
    return await databaseHelper.deleteStatus(status.toMap());
  }
}
