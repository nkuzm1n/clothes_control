import 'dart:io';

abstract class IImageRepository {
  Future<File> saveImage(File image);
  Future<File?> getImage(String path);
}
