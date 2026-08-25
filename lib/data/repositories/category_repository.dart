import 'package:clothes_control/data/dto/category/new_category_dto.dart';
import 'package:clothes_control/data/local/database_helper.dart';
import 'package:clothes_control/domain/entities/category.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final DatabaseHelper databaseHelper;

  CategoryRepositoryImpl({required this.databaseHelper});

  @override
  Future<List<Category>> getManyBy({List<int>? id}) async {
    final result = await databaseHelper.getCategories(id: id);
    return result.map((item) => Category.fromJson(item)).toList();
  }

  @override
  Future<Category?> getOneById(int id) async {
    final result = await databaseHelper.getCategory(id);
    return result.isNotEmpty ? Category.fromJson(result) : null;
  }

  @override
  Future<Category> createOne(NewCategoryDto category) async {
    final id = await databaseHelper.insertCategory(category.toJson());
    final result = await getOneById(id);
    return result!;
  }

  @override
  Future<int> updateOne(Category category) async {
    return await databaseHelper.updateCategory(category.toJson());
  }

  @override
  Future<int> deleteOne(Category category) async {
    return await databaseHelper.deleteCategory(category.toJson());
  }
}
