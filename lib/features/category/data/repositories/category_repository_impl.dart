import 'package:clothes_control/features/category/data/datasources/category_datasource.dart';
import 'package:clothes_control/features/category/data/mappers/category_mapper.dart';
import 'package:clothes_control/shared/domain/entities/category.dart';
import 'package:clothes_control/shared/domain/repositories/params/category/create_category_params.dart';
import 'package:clothes_control/shared/domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements ICategoryRepository {
  final CategoryDataSource dataSource;

  CategoryRepositoryImpl({required this.dataSource});

  @override
  Future<List<Category>> getManyBy({List<int>? id}) async {
    final result = await dataSource.getAll(id: id);
    return result.map((item) => CategoryMapper.fromModel(item)).toList();
  }

  @override
  Future<Category?> getOneById(int id) async {
    final model = await dataSource.getById(id);
    return model == null ? null : CategoryMapper.fromModel(model);
  }

  @override
  Future<Category> createOne(CreateCategoryParams params) async {
    final id = await dataSource.create(CategoryMapper.createParamsToModel(params));
    final created = await dataSource.getById(id);
    return created == null ? throw StateError('Unable to load newly created category') : CategoryMapper.fromModel(created);
  }

  @override
  Future<int> updateOne(Category category) async {
    return await dataSource.update(CategoryMapper.toModel(category));
  }

  @override
  Future<int> deleteOne(int id) async {
    return await dataSource.deleteById(id);
  }

}
