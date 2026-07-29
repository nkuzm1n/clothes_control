import 'package:clothes_control/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/data/dto/cloth/new_cloth_dto.dart';

abstract class IClothesRepository {
  Future<List<ClothDTO>> getManyBy({
    String? name,
    int? statusId,
    int? categoryId,
    String? orderBy,
    String? direction,
  });
  Future<ClothDTO?> getOneById(int itemId);
  Future<void> deleteOne(int itemId);
  Future<int> updateOne(ClothDTO item);
  Future<int> createOne(NewClothDTO item);
}
