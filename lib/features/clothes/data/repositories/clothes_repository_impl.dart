import 'package:clothes_control/features/clothes/data/datasources/cloth_datasource.dart';
import 'package:clothes_control/features/clothes/data/mappers/cloth_mapper.dart';
import 'package:clothes_control/features/clothes/domain/entities/cloth.dart';
import 'package:clothes_control/features/clothes/domain/repositories/params/cloth/create_cloth_params.dart';
import 'package:clothes_control/features/clothes/domain/repositories/clothes_repository.dart';

class ClothesRepositoryImpl implements IClothesRepository {
  final ClothesDataSource dataSource;

  ClothesRepositoryImpl({required this.dataSource});

  @override
  Future<List<Cloth>> getManyBy({
    String? name,
    int? statusId,
    int? categoryId,
    String? orderBy,
    String? direction,
  }) async {
    final result = await dataSource.getAll(
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
    final model = await dataSource.getById(itemId);
    return model == null ? null : ClothMapper.fromModel(model);
  }

  @override
  Future<void> deleteOne(int itemId) async {
    await dataSource.deleteById(itemId);
  }

  @override
  Future<int> updateOne(Cloth cloth) async {
    return await dataSource.update(ClothMapper.toModel(cloth));
  }

  @override
  Future<int> createOne(CreateClothParams createParams) async {
    return await dataSource.create(ClothMapper.createParamsToModel(createParams));
  }
}
