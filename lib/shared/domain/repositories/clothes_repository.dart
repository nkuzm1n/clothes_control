import 'package:clothes_control/shared/data/dto/cloth_list_item_dto.dart';
import 'package:clothes_control/shared/data/dto/new_cloth_dto.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';

abstract class IClothesRepository {
  Future<List<Cloth>> getClothesList();
  Future<Cloth> getClothById(int itemId);
  Future<void> deleteCloth(int itemId);
  Future<int> updateCloth(Cloth item);
  Future<int> addCloth(NewClothDTO item);
}
