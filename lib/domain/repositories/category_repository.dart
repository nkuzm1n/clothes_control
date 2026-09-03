import 'package:clothes_control/domain/repositories/params/category/create_category_params.dart';
import 'package:clothes_control/domain/entities/category.dart';

abstract class ICategoryRepository {
  Future<List<Category>> getManyBy({List<int>? id});
  Future<Category?> getOneById(int id);
  Future<Category> createOne(CreateCategoryParams category);
  Future<int> updateOne(Category category);
  Future<int> deleteOne(int category);
}
