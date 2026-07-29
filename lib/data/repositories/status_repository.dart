import 'package:clothes_control/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/data/dto/status/status_dto.dart';
import 'package:clothes_control/data/local/database_helper.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';

class StatusRepositoryImpl implements IStatusRepository {
  final DatabaseHelper databaseHelper;

  StatusRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<StatusDTO>> getManyBy({List<int>? id}) async {
    final result = await databaseHelper.getStatuses(id: id);
    return result.map((item) => StatusDTO.fromMap(item)).toList();
  }

  @override
  Future<StatusDTO?> getOneById(int id) async {
    final result = await databaseHelper.getStatus(id);
    return result.isNotEmpty ? StatusDTO.fromMap(result) : null;
  }

  @override
  Future<StatusDTO> createOne(NewStatusDTO status) async {
    final id = await databaseHelper.insertStatus(status.toMap());
    final result = await getOneById(id);
    return result!;
  }

  @override
  Future<int> updateOne(StatusDTO status) async {
    return await databaseHelper.updateStatus(status.toMap());
  }

  @override
  Future<int> deleteOne(StatusDTO status) async {
    return await databaseHelper.deleteStatus(status.toMap());
  }
}
