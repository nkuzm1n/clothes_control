import 'package:clothes_control/shared/domain/entities/cloth.dart';

abstract class IClothesRepository {
  Future<List<Cloth>> getClothesList();
  Future<Cloth> getClothesItemById(int itemId);
  Future<void> deleteClothesItem(int itemId);
  Future<void> updateClothesItem(Cloth item);
  Future<void> addClothesItem(Cloth item);
}
