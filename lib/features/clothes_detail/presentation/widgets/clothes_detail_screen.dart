import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/clothes_detail/presentation/widgets/clothes_detail_form.dart';
import 'package:clothes_control/features/clothes_list/presentation/widgets/clothes_list_screen.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/data/repositories/clothes_repository.dart';
import 'package:clothes_control/shared/data/repositories/condition_repository.dart';
import 'package:clothes_control/shared/data/repositories/image_repository.dart';
import 'package:clothes_control/shared/data/repositories/status_repository.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/text/ui_text_no_data.dart';
import 'package:clothes_control/features/clothes_detail/presentation/bloc/clothes_detail_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ClothesDetailScreen extends StatelessWidget {
  final int itemId;

  const ClothesDetailScreen({super.key, required this.itemId});

  // TODO: to image picker component
  Future<String?> uploadImageAndSaveLocally() async {
    final picker = ImagePicker();
    XFile? pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile == null) {
      print("NO FILE PICKED");
      return null;
    }

    File imageFile = File(pickedFile.path);
    // await saveImageLocally(imageFile);

    // Теперь вы можете использовать путь к файлу для отображения изображения
    String imagePath = imageFile.path;
    print("FILE PICKED: $imagePath");
    return imagePath;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClothesDetailBloc(
        clothesRepository: ClothesRepository(databaseHelper: DatabaseHelper.instance),
        conditionRepository: ConditionRepository(databaseHelper: DatabaseHelper.instance),
        statusRepository: StatusRepository(databaseHelper: DatabaseHelper.instance),
        imageRepository: ImageRepository(),
      )..add(LoadClothesDetail(itemId: itemId)),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Подробнее',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                context.read<ClothesDetailBloc>().add(DeleteClothesItem(itemId: itemId));
                Navigator.pop(context);
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: BlocConsumer<ClothesDetailBloc, ClothesDetailState>(
            listener: (context, state) {
              if (state is ClothesItemDeleted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClothesListScreen(),
                  ),
                );
              }
            },
            builder: (context, state) {
              return Stack(
                children: [
                  if (state is ClothesDetailLoaded) ClothesDetailForm(cloth: state.cloth),
                  if (state is! ClothesDetailLoading)
                    if (state is ClothesDetailError)
                      Center(child: Text(state.message))
                    else
                      const UiTextNoData(),
                  if (state is ClothesDetailLoading)
                    Positioned.fill(
                      child: Container(
                        color: const Color.fromRGBO(0, 0, 0, 0.2),
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
