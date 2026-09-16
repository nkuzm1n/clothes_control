import 'dart:io';

abstract class IImageRepository {
  Future<File> save(File image);
  Future<File?> getByPath(String path);
}
