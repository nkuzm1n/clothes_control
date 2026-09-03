import 'package:clothes_control/domain/repositories/params/status/create_status_params.dart';
import 'package:clothes_control/data/database/database_helper.dart';
import 'package:clothes_control/data/mappers/status_mapper.dart';
import 'package:clothes_control/domain/entities/status.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';

class StatusRepositoryImpl implements IStatusRepository {
  final SqliteDatabase sqliteDatabase;

  StatusRepositoryImpl({required this.sqliteDatabase});

  @override
  Future<List<Status>> getManyBy({List<int>? id}) async {
    final result = await sqliteDatabase.getStatuses(id: id);
    return result.map((item) => StatusMapper.fromModel(item)).toList();
  }

  @override
  Future<Status?> getOneById(int id) async {
    final result = await sqliteDatabase.getStatus(id);
    return result != null ? StatusMapper.fromModel(result) : null;
  }

  @override
  Future<Status> createOne(CreateStatusParams createParams) async {
    final id = await sqliteDatabase.insertStatus(StatusMapper.createParamsToModel(createParams));
    final result = await getOneById(id);
    return result!;
  }

  @override
  Future<int> updateOne(Status status) async {
    return await sqliteDatabase.updateStatus(StatusMapper.toModel(status));
  }

  @override
  Future<int> deleteOne(int id) async {
    return await sqliteDatabase.deleteStatus(id);
  }
}
