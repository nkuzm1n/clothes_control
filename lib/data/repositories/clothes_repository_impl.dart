import 'package:clothes_control/domain/repositories/params/cloth/create_cloth_params.dart';
import 'package:clothes_control/data/database/database_helper.dart';
import 'package:clothes_control/data/mappers/cloth_mapper.dart';
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
    return result.map((item) => ClothMapper.fromModel(item)).toList();
  }

  @override
  Future<Cloth?> getOneById(int itemId) async {
    final result = await sqliteDatabase.getCloth(itemId);
    return result != null ? ClothMapper.fromModel(result) : null;
  }

  @override
  Future<int> createOne(CreateClothParams createParams) async {
    return await sqliteDatabase.insertCloth(ClothMapper.createParamsToModel(createParams));
  }

  @override
  Future<void> deleteOne(int itemId) async {
    await sqliteDatabase.deleteClothById(itemId);
  }

  @override
  Future<int> updateOne(Cloth cloth) async {
    return await sqliteDatabase.updateCloth(ClothMapper.toModel(cloth));
  }
}
