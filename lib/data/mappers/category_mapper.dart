import 'package:clothes_control/data/database/models/category_model.dart';
import 'package:clothes_control/domain/entities/category.dart';
import 'package:clothes_control/domain/repositories/params/category/create_category_params.dart';

class CategoryMapper {
  static Category fromModel(CategoryModel category) {
    return Category(
      id: category.id!,
      name: category.name,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  static CategoryModel toModel(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  static CategoryModel createParamsToModel(CreateCategoryParams category) {
    return CategoryModel(
      id: null,
      name: category.name,
    );
  }
}
