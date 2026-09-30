import 'package:clothes_control/features/category/data/datasources/category_datasource.dart';
import 'package:clothes_control/features/category/data/repositories/category_repository_impl.dart';
import 'package:clothes_control/features/clothes/data/datasources/cloth_datasource.dart';
import 'package:clothes_control/features/clothes/data/repositories/clothes_repository_impl.dart';
import 'package:clothes_control/features/status/data/datasources/status_datasource.dart';
import 'package:clothes_control/features/status/data/repositories/status_repository_impl.dart';
import 'package:clothes_control/shared/data/database/database.dart';
import 'package:clothes_control/shared/data/repositories/image_repository_impl.dart';
import 'package:clothes_control/shared/domain/repositories/category_repository.dart';
import 'package:clothes_control/shared/domain/repositories/image_repository.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';
import 'package:clothes_control/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:clothes_control/core/di/service_locator.dart';

class ServiceLocator {
  static Future<void> setup() async {
    sl.registerLazySingleton(() => SqliteDatabase());

    sl.registerLazySingleton<ClothesDataSource>(
      () => ClothesDataSource(sl<SqliteDatabase>()),
    );
    sl.registerLazySingleton<StatusDataSource>(
      () => StatusDataSource(sl<SqliteDatabase>()),
    );
    sl.registerLazySingleton<CategoryDataSource>(
      () => CategoryDataSource(sl<SqliteDatabase>()),
    );

    sl.registerLazySingleton<IClothesRepository>(
      () => ClothesRepositoryImpl(dataSource: sl<ClothesDataSource>()),
    );
    sl.registerLazySingleton<IStatusRepository>(
      () => StatusRepositoryImpl(dataSource: sl<StatusDataSource>()),
    );
    sl.registerLazySingleton<ICategoryRepository>(
      () => CategoryRepositoryImpl(dataSource: sl<CategoryDataSource>()),
    );

    sl.registerLazySingleton<IImageRepository>(
      () => ImageRepositoryImpl(),
    );

    final db = sl<SqliteDatabase>();

    db.registerSeed(() async {
      await sl<StatusDataSource>().seed();
    });
    db.registerSeed(() async {
      await sl<CategoryDataSource>().seed();
    });
  }
}
