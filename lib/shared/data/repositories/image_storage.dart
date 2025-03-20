import 'dart:io';
import 'package:clothes_control/shared/domain/repositories/image_repository.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class ImageStorage implements IImageRepository {
  @override
  Future<File> saveImage(File image) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = basename(image.path);
    final savedImage = await image.copy('${directory.path}/$fileName');
    return savedImage;
  }

  @override
  Future<File?> getImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      return file;
    }
    return null;
  }
}
