import 'package:clothes_control/data/dto/category/category_dto.dart';
import 'package:clothes_control/data/dto/category/new_category_dto.dart';
import 'package:clothes_control/data/local/database_helper.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final DatabaseHelper databaseHelper;

  CategoryRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<CategoryDTO>> getManyBy({List<int>? id}) async {
    final result = await databaseHelper.getCategories(id: id);
    return result.map((item) => CategoryDTO.fromMap(item)).toList();
  }

  @override
  Future<CategoryDTO?> getOneById(int id) async {
    final result = await databaseHelper.getCategory(id);
    return result.isNotEmpty ? CategoryDTO.fromMap(result) : null;
  }

  @override
  Future<CategoryDTO> createOne(NewCategoryDTO category) async {
    final id = await databaseHelper.insertCategory(category.toMap());
    final result = await getOneById(id);
    return result!;
  }

  @override
  Future<int> updateOne(CategoryDTO category) async {
    return await databaseHelper.updateCategory(category.toMap());
  }

  @override
  Future<int> deleteOne(CategoryDTO category) async {
    return await databaseHelper.deleteCategory(category.toMap());
  }
}
