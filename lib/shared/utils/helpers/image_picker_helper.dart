import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<XFile?> pickImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  static Future<XFile?> pickImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    return pickedFile;
  }
}
