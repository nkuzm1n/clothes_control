import 'package:clothes_control/core/data/dto/category/category_dto.dart';
import 'package:clothes_control/core/data/dto/category/new_category_dto.dart';

abstract class ICategoryRepository {
  Future<List<CategoryDTO>> getCategories({List<int>? id});
  Future<CategoryDTO?> getCategoryById(int id);
  Future<CategoryDTO> addCategory(NewCategoryDTO status);
  Future<int> updateCategory(CategoryDTO category);
  Future<int> deleteCategory(CategoryDTO category);
}
