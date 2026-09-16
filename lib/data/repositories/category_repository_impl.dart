import 'package:clothes_control/domain/repositories/params/category/create_category_params.dart';
import 'package:clothes_control/data/database/database_helper.dart';
import 'package:clothes_control/data/mappers/category_mapper.dart';
import 'package:clothes_control/domain/entities/category.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final SqliteDatabase sqliteDatabase;

  CategoryRepositoryImpl({required this.sqliteDatabase});

  @override
  Future<List<Category>> getManyBy({List<int>? id}) async {
    final result = await sqliteDatabase.getCategories(id: id);
    return result.map((item) => CategoryMapper.fromModel(item)).toList();
  }

  @override
  Future<Category?> getOneById(int id) async {
    final dto = await sqliteDatabase.getCategory(id);
    return dto != null ? CategoryMapper.fromModel(dto) : null;
  }

  @override
  Future<Category> createOne(CreateCategoryParams createCategoryParams) async {
    final id = await sqliteDatabase.insertCategory(
      CategoryMapper.createParamsToModel(createCategoryParams),
    );
    final result = await getOneById(id);
    return result!;
  }

  @override
  Future<int> updateOne(Category category) async {
    return await sqliteDatabase.updateCategory(CategoryMapper.toModel(category));
  }

  @override
  Future<int> deleteOne(int id) async {
    return await sqliteDatabase.deleteCategory(id);
  }
}
