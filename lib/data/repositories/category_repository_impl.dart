import 'package:clothes_control/data/dto/category/new_category_dto.dart';
import 'package:clothes_control/data/database/database_helper.dart';
import 'package:clothes_control/domain/entities/category.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final SqliteDatabase sqliteDatabase;

  CategoryRepositoryImpl({required this.sqliteDatabase});

  @override
  Future<List<Category>> getManyBy({List<int>? id}) async {
    final result = await sqliteDatabase.getCategories(id: id);
    return result.map((item) => Category.fromJson(item)).toList();
  }

  @override
  Future<Category?> getOneById(int id) async {
    final result = await sqliteDatabase.getCategory(id);
    return result.isNotEmpty ? Category.fromJson(result) : null;
  }

  @override
  Future<Category> createOne(NewCategoryDto category) async {
    final id = await sqliteDatabase.insertCategory(category.toJson());
    final result = await getOneById(id);
    return result!;
  }

  @override
  Future<int> updateOne(Category category) async {
    return await sqliteDatabase.updateCategory(category.toJson());
  }

  @override
  Future<int> deleteOne(int id) async {
    return await sqliteDatabase.deleteCategory(id);
  }
}
