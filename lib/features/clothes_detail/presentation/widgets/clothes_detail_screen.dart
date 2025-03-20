import 'dart:io';

import 'package:clothes_control/features/clothes_list/presentation/widgets/clothes_list_screen.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/data/repositories/clothes_repository.dart';
import 'package:clothes_control/shared/data/repositories/condition_repository.dart';
import 'package:clothes_control/shared/data/repositories/image_storage.dart';
import 'package:clothes_control/shared/data/repositories/status_repository.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/image/ui_image.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/text/ui_text_no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/clothes_detail/presentation/bloc/clothes_detail_bloc.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
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
        clothesRepository: ClothesRepository(databaseHelper: DatabaseHelper()),
        conditionRepository: ConditionRepository(databaseHelper: DatabaseHelper()),
        statusRepository: StatusRepository(databaseHelper: DatabaseHelper()),
        imageRepository: ImageStorage(),
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
              if (state is ClothesDetailLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ClothesDetailLoaded) {
                return _buildDetailForm(context, state.clothesItem);
              } else if (state is ClothesDetailError) {
                return Center(child: Text(state.message));
              } else {
                return const UiTextNoData();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildDetailForm(BuildContext context, Cloth clothesItem) {
    final nameController = TextEditingController(text: clothesItem.name);
    final descriptionController = TextEditingController(text: clothesItem.description);
    final statusController = TextEditingController(text: clothesItem.status.name);
    final conditionController = TextEditingController(text: clothesItem.condition.name);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // if (clothesItem.imageUrl != null)
          //   Image.network(clothesItem.imageUrl!),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Наименование'),
            maxLines: null,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Описание'),
            maxLines: null,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: statusController,
            decoration: const InputDecoration(labelText: 'Статус'),
          ),

          const SizedBox(height: 8),
          TextField(
            controller: conditionController,
            decoration: const InputDecoration(labelText: 'Состояние'),
          ),

          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiImage(
                image: clothesItem.imageUrl != null ? NetworkImage(clothesItem.imageUrl!) : null,
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    final String? url = await uploadImageAndSaveLocally();
                    print("URL OF PHOTO IS $url");
                  },
                  child: const Text('Загрузить'),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () {
                // TODO:
                // final updatedItem = Cloth(
                //   id: clothesItem.id,
                //   name: nameController.text,
                //   description: descriptionController.text,
                //   condition: conditionController.text,
                //   status: statusController.text,
                //   imageUrl: clothesItem.imageUrl,
                // );
                // context.read<ClothesDetailBloc>().add(UpdateClothesItem(updatedItem: updatedItem));
              },
              child: const Text('Сохранить'),
            ),
          ),
        ],
      ),
    );
  }
}
