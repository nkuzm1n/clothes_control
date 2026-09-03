import 'package:clothes_control/data/database/models/cloth_model.dart';
import 'package:clothes_control/domain/entities/cloth.dart';
import 'package:clothes_control/domain/repositories/params/cloth/create_cloth_params.dart';

class ClothMapper {
  static Cloth fromModel(ClothModel cloth) {
    return Cloth(
      id: cloth.id!,
      name: cloth.name,
      description: cloth.description,
      statusId: cloth.statusId,
      categoryId: cloth.categoryId,
      imageUrl: cloth.imageUrl,
      createdAt: cloth.createdAt,
      updatedAt: cloth.updatedAt,
    );
  }

  static ClothModel toModel(Cloth cloth) {
    return ClothModel(
      id: cloth.id,
      name: cloth.name,
      description: cloth.description,
      statusId: cloth.statusId,
      categoryId: cloth.categoryId,
      imageUrl: cloth.imageUrl,
      createdAt: cloth.createdAt,
      updatedAt: cloth.updatedAt,
    );
  }

  static ClothModel createParamsToModel(CreateClothParams createParams) {
    return ClothModel(
      id: null,
      name: createParams.name,
      description: createParams.description,
      statusId: createParams.statusId,
      categoryId: createParams.categoryId,
      imageUrl: createParams.imageUrl,
    );
  }
}
