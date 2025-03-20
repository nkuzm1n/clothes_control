import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/repositories/clothes_repository.dart';

class ClothesRepository implements IClothesRepository {
  final DatabaseHelper databaseHelper;

  ClothesRepository({required this.databaseHelper});

  @override
  Future<List<Cloth>> getClothesList() async {
    final result = await databaseHelper.getClothesList();
    return result.map((item) => Cloth.fromMap(item)).toList();
  }

  @override
  Future<Cloth> getClothesItemById(int itemId) async {
    final result = await databaseHelper.getClothesItem(itemId);
    return Cloth.fromMap(result);
  }

  @override
  Future<void> deleteClothesItem(int itemId) async {
    await databaseHelper.deleteClothesItem(itemId);
  }

  @override
  Future<void> updateClothesItem(Cloth item) async {
    await databaseHelper.updateClothesItem(item.toMap());
  }

  @override
  Future<void> addClothesItem(Cloth item) async {
    await databaseHelper.insertClothesItem(item.toMap());
  }
}
