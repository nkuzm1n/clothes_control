import 'package:clothes_control/shared/data/dto/cloth_list_item_dto.dart';
import 'package:clothes_control/shared/data/dto/new_cloth_dto.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/repositories/clothes_repository.dart';

class ClothesRepository implements IClothesRepository {
  final DatabaseHelper databaseHelper;

  ClothesRepository({required this.databaseHelper});

  @override
  Future<List<Cloth>> getClothesList() async {
    final result = await databaseHelper.getClothesList();
    print("results $result");
    return result.map((item) => Cloth.fromMap(item)).toList();
  }

  @override
  Future<Cloth> getClothById(int itemId) async {
    final result = await databaseHelper.getCloth(itemId);
    return Cloth.fromMap(result);
  }

  @override
  Future<void> deleteCloth(int itemId) async {
    await databaseHelper.deleteCloth(itemId);
  }

  @override
  Future<int> updateCloth(Cloth item) async {
    return await databaseHelper.updateCloth(item.toMap());
  }

  @override
  Future<int> addCloth(NewClothDTO item) async {
    return await databaseHelper.insertCloth(item.toMap());
  }
}
