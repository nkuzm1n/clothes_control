import 'package:clothes_control/shared/domain/entities/cloth.dart';

abstract class IClothesRepository {
  Future<List<Cloth>> getClothesList();
  Future<Cloth> getClothById(int itemId);
  Future<void> deleteCloth(int itemId);
  Future<void> updateCloth(Cloth item);
  Future<void> addCloth(Cloth item);
}
