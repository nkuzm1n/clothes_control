import 'package:clothes_control/shared/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/domain/repositories/clothes_repository.dart';

class ClothesRepositoryImpl implements IClothesRepository {
  final DatabaseHelper databaseHelper;

  ClothesRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<ClothDTO>> getClothesList({
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
    return result.map((item) => ClothDTO.fromMap(item)).toList();
  }

  @override
  Future<ClothDTO?> getClothById(int itemId) async {
    final result = await databaseHelper.getCloth(itemId);
    return result.isNotEmpty ? ClothDTO.fromMap(result) : null;
  }

  @override
  Future<int> addCloth(NewClothDTO item) async {
    return await databaseHelper.insertCloth(item.toMap());
  }

  @override
  Future<void> deleteCloth(int itemId) async {
    await databaseHelper.deleteCloth(itemId);
  }

  @override
  Future<int> updateCloth(ClothDTO item) async {
    return await databaseHelper.updateCloth(item.toMap());
  }
}
