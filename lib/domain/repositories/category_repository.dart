import 'package:clothes_control/data/dto/category/new_category_dto.dart';
import 'package:clothes_control/domain/entities/category.dart';

abstract class ICategoryRepository {
  Future<List<Category>> getManyBy({List<int>? id});
  Future<Category?> getOneById(int id);
  Future<Category> createOne(NewCategoryDto category);
  Future<int> updateOne(Category category);
  Future<int> deleteOne(int category);
}
