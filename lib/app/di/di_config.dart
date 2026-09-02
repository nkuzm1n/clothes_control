import 'package:clothes_control/data/database/database_helper.dart';
import 'package:clothes_control/data/repositories/category_repository_impl.dart';
import 'package:clothes_control/data/repositories/clothes_repository_impl.dart';
import 'package:clothes_control/data/repositories/image_repository_impl.dart';
import 'package:clothes_control/data/repositories/status_repository_impl.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';
import 'package:clothes_control/domain/repositories/clothes_repository.dart';
import 'package:clothes_control/domain/repositories/image_repository.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';
import 'package:clothes_control/core/di/di.dart';

void initRepositories() {
  final sqliteDatabase = sl.registerSingleton<SqliteDatabase>(SqliteDatabase());

  sl.registerLazySingleton<IClothesRepository>(
    () => ClothesRepositoryImpl(sqliteDatabase: sqliteDatabase),
  );

  sl.registerLazySingleton<ICategoryRepository>(
    () => CategoryRepositoryImpl(sqliteDatabase: sqliteDatabase),
  );

  sl.registerLazySingleton<IStatusRepository>(
    () => StatusRepositoryImpl(sqliteDatabase: sqliteDatabase),
  );

  sl.registerLazySingleton<IImageRepository>(
    () => ImageRepositoryImpl(),
  );
}
