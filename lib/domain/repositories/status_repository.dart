import 'package:clothes_control/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/domain/entities/status.dart';

abstract class IStatusRepository {
  Future<List<Status>> getManyBy({List<int>? id});
  Future<Status?> getOneById(int id);
  Future<Status> createOne(NewStatusDto status);
  Future<int> updateOne(Status status);
  Future<int> deleteOne(int id);
}
