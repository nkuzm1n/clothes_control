import 'package:clothes_control/core/data/dto/category/category_dto.dart';
import 'package:clothes_control/core/data/dto/category/new_category_dto.dart';
import 'package:clothes_control/core/data/local/database_helper.dart';
import 'package:clothes_control/core/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final DatabaseHelper databaseHelper;

  CategoryRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<CategoryDTO>> getCategories({List<int>? id}) async {
    final result = await databaseHelper.getCategories(id: id);
    return result.map((item) => CategoryDTO.fromMap(item)).toList();
  }

  @override
  Future<CategoryDTO?> getCategoryById(int id) async {
    final result = await databaseHelper.getCategory(id);
    return result.isNotEmpty ? CategoryDTO.fromMap(result) : null;
  }

  @override
  Future<CategoryDTO> addCategory(NewCategoryDTO category) async {
    final id = await databaseHelper.insertCategory(category.toMap());
    final result = await getCategoryById(id);
    return result!;
  }

  @override
  Future<int> updateCategory(CategoryDTO category) async {
    return await databaseHelper.updateCategory(category.toMap());
  }

  @override
  Future<int> deleteCategory(CategoryDTO category) async {
    return await databaseHelper.deleteCategory(category.toMap());
  }
}
