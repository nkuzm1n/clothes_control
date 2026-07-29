import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UiImagePicker extends StatefulWidget {
  final File? image;
  final XFile? pickFile;
  final Function(File)? onImageSelected;

  const UiImagePicker({super.key, this.image, this.onImageSelected, this.pickFile});

  @override
  State<UiImagePicker> createState() => _UiImagePickerState();
}

class _UiImagePickerState extends State<UiImagePicker> {
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(_imageFile!);
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      if (widget.onImageSelected != null) {
        widget.onImageSelected!(_imageFile!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () => _pickImageFromGallery(),
          child: const Text('Pick from Gallery'),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () => _pickImageFromCamera(),
          child: const Text('Pick from Camera'),
        ),
        Image.file(widget.image ?? (_imageFile ?? File('path/to/default/image.jpg')),
            height: 200, width: 200),
      ],
    );
  }
}
