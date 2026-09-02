import 'package:clothes_control/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/data/database/database_helper.dart';
import 'package:clothes_control/domain/entities/status.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';

class StatusRepositoryImpl implements IStatusRepository {
  final SqliteDatabase databaseHelper;

  StatusRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<Status>> getManyBy({List<int>? id}) async {
    final result = await databaseHelper.getStatuses(id: id);
    return result.map((item) => Status.fromJson(item)).toList();
  }

  @override
  Future<Status?> getOneById(int id) async {
    final result = await databaseHelper.getStatus(id);
    return result.isNotEmpty ? Status.fromJson(result) : null;
  }

  @override
  Future<Status> createOne(NewStatusDto status) async {
    final id = await databaseHelper.insertStatus(status.toJson());
    final result = await getOneById(id);
    return result!;
  }

  @override
  Future<int> updateOne(Status status) async {
    return await databaseHelper.updateStatus(status.toJson());
  }

  @override
  Future<int> deleteOne(int id) async {
    return await databaseHelper.deleteStatus(id);
  }
}
