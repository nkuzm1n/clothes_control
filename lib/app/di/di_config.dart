import 'package:clothes_control/shared/data/database/database_helper.dart';
import 'package:clothes_control/features/category/data/repositories/category_repository_impl.dart';
import 'package:clothes_control/features/clothes/data/repositories/clothes_repository_impl.dart';
import 'package:clothes_control/shared/data/repositories/image_repository_impl.dart';
import 'package:clothes_control/features/status/data/repositories/status_repository_impl.dart';
import 'package:clothes_control/shared/domain/repositories/category_repository.dart';
import 'package:clothes_control/features/clothes/domain/repositories/clothes_repository.dart';
import 'package:clothes_control/shared/domain/repositories/image_repository.dart';
import 'package:clothes_control/shared/domain/repositories/status_repository.dart';
import 'package:clothes_control/core/di/service_locator.dart';

class ServiceLocator {
  static void setup() {
    sl.registerLazySingleton<SqliteDatabase>(() => SqliteDatabase());

    sl.registerLazySingleton<IClothesRepository>(
      () => ClothesRepositoryImpl(sqliteDatabase: sl<SqliteDatabase>()),
    );

    sl.registerLazySingleton<ICategoryRepository>(
      () => CategoryRepositoryImpl(sqliteDatabase: sl<SqliteDatabase>()),
    );

    sl.registerLazySingleton<IStatusRepository>(
      () => StatusRepositoryImpl(sqliteDatabase: sl<SqliteDatabase>()),
    );

    sl.registerLazySingleton<IImageRepository>(
      () => ImageRepositoryImpl(),
    );
  }
}
