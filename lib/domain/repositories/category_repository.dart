import 'package:clothes_control/data/dto/category/category_dto.dart';
import 'package:clothes_control/data/dto/category/new_category_dto.dart';

abstract class ICategoryRepository {
  Future<List<CategoryDTO>> getManyBy({List<int>? id});
  Future<CategoryDTO?> getOneById(int id);
  Future<CategoryDTO> createOne(NewCategoryDTO categoryDto);
  Future<int> updateOne(CategoryDTO category);
  Future<int> deleteOne(CategoryDTO category);
}
