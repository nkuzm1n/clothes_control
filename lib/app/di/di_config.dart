import 'package:clothes_control/data/database/database_helper.dart';
import 'package:clothes_control/data/repositories/category_repository_impl.dart';
import 'package:clothes_control/data/repositories/clothes_repository_impl.dart';
import 'package:clothes_control/data/repositories/image_repository_impl.dart';
import 'package:clothes_control/data/repositories/status_repository_impl.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';
import 'package:clothes_control/domain/repositories/clothes_repository.dart';
import 'package:clothes_control/domain/repositories/image_repository.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';
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
