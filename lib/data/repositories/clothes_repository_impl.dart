import 'package:clothes_control/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/data/database/database_helper.dart';
import 'package:clothes_control/domain/entities/cloth.dart';
import 'package:clothes_control/domain/repositories/clothes_repository.dart';

class ClothesRepositoryImpl implements IClothesRepository {
  final SqliteDatabase sqliteDatabase;

  ClothesRepositoryImpl({required this.sqliteDatabase});

  @override
  Future<List<Cloth>> getManyBy({
    String? name,
    int? statusId,
    int? categoryId,
    String? orderBy,
    String? direction,
  }) async {
    final result = await sqliteDatabase.getClothesList(
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
    final result = await sqliteDatabase.getCloth(itemId);
    return result.isNotEmpty ? Cloth.fromJson(result) : null;
  }

  @override
  Future<int> createOne(NewClothDto item) async {
    return await sqliteDatabase.insertCloth(item.toJson());
  }

  @override
  Future<void> deleteOne(int itemId) async {
    await sqliteDatabase.deleteCloth(itemId);
  }

  @override
  Future<int> updateOne(Cloth item) async {
    return await sqliteDatabase.updateCloth(item.toJson());
  }
}
