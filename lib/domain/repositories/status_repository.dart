import 'package:clothes_control/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/data/dto/status/status_dto.dart';

abstract class IStatusRepository {
  Future<List<StatusDTO>> getManyBy({List<int>? id});
  Future<StatusDTO?> getOneById(int id);
  Future<StatusDTO> createOne(NewStatusDTO status);
  Future<int> updateOne(StatusDTO status);
  Future<int> deleteOne(StatusDTO status);
}
