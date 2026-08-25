import 'package:clothes_control/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/domain/entities/cloth.dart';

abstract class IClothesRepository {
  Future<List<Cloth>> getManyBy({
    String? name,
    int? statusId,
    int? categoryId,
    String? orderBy,
    String? direction,
  });
  Future<Cloth?> getOneById(int itemId);
  Future<void> deleteOne(int itemId);
  Future<int> updateOne(Cloth item);
  Future<int> createOne(NewClothDto item);
}
