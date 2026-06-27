import 'package:clothes_control/core/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/core/data/dto/cloth/new_cloth_dto.dart';

abstract class IClothesRepository {
  Future<List<ClothDTO>> getClothesList({
    String? name,
    int? statusId,
    int? categoryId,
    String? orderBy,
    String? direction,
  });
  Future<ClothDTO?> getClothById(int itemId);
  Future<void> deleteCloth(int itemId);
  Future<int> updateCloth(ClothDTO item);
  Future<int> addCloth(NewClothDTO item);
}
