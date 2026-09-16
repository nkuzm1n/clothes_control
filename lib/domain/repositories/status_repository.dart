import 'package:clothes_control/domain/repositories/params/status/create_status_params.dart';
import 'package:clothes_control/domain/entities/status.dart';

abstract class IStatusRepository {
  Future<List<Status>> getManyBy({List<int>? id});
  Future<Status?> getOneById(int id);
  Future<Status> createOne(CreateStatusParams status);
  Future<int> updateOne(Status status);
  Future<int> deleteOne(int id);
}
