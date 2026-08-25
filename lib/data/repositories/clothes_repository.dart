import 'package:clothes_control/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/data/local/database_helper.dart';
import 'package:clothes_control/domain/entities/cloth.dart';
import 'package:clothes_control/domain/repositories/clothes_repository.dart';

class ClothesRepositoryImpl implements IClothesRepository {
  final DatabaseHelper databaseHelper;

  ClothesRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<Cloth>> getManyBy({
    String? name,
    int? statusId,
    int? categoryId,
    String? orderBy,
    String? direction,
  }) async {
    final result = await databaseHelper.getClothesList(
      name: name,
      statusId: statusId,
      categoryId: categoryId,
      orderBy: orderBy,
      direction: direction,
    );
    return result.map((item) => Cloth.fromJson(item)).toList();
  }

  @override
  Future<Cloth?> getOneById(int itemId) async {
    final result = await databaseHelper.getCloth(itemId);
    return result.isNotEmpty ? Cloth.fromJson(result) : null;
  }

  @override
  Future<int> createOne(NewClothDto item) async {
    return await databaseHelper.insertCloth(item.toJson());
  }

  @override
  Future<void> deleteOne(int itemId) async {
    await databaseHelper.deleteCloth(itemId);
  }

  @override
  Future<int> updateOne(Cloth item) async {
    return await databaseHelper.updateCloth(item.toJson());
  }
}
