import 'package:clothes_control/features/status/data/datasources/status_datasource.dart';
import 'package:clothes_control/features/status/data/mappers/status_mapper.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:clothes_control/shared/domain/repositories/params/status/create_status_params.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';

class StatusRepositoryImpl implements IStatusRepository {
  final StatusDataSource dataSource;

  StatusRepositoryImpl({required this.dataSource});

  @override
  Future<List<Status>> getManyBy({List<int>? id}) async {
    final result = await dataSource.getAll(id: id);
    return result.map((item) => StatusMapper.fromModel(item)).toList();
  }

  @override
  Future<Status?> getOneById(int id) async {
    final model = await dataSource.getById(id);
    return model == null ? null : StatusMapper.fromModel(model);
  }

  @override
  Future<Status> createOne(CreateStatusParams params) async {
    final id = await dataSource.create(StatusMapper.createParamsToModel(params));
    final created = await dataSource.getById(id);
    return created == null ? throw StateError('Unable to load newly created status') : StatusMapper.fromModel(created);
  }

  @override
  Future<int> updateOne(Status status) async {
    return await dataSource.update(StatusMapper.toModel(status));
  }

  @override
  Future<int> deleteOne(int id) async {
    return await dataSource.deleteById(id);
  }

}
