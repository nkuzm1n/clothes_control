import 'dart:io';
import 'package:clothes_control/shared/data/dto/new_cloth_dto.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/clothes_detail/presentation/widgets/clothes_detail_form.dart';
import 'package:clothes_control/features/clothes_list/presentation/widgets/clothes_list_screen.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/data/repositories/clothes_repository.dart';
import 'package:clothes_control/shared/data/repositories/condition_repository.dart';
import 'package:clothes_control/shared/data/repositories/image_repository.dart';
import 'package:clothes_control/shared/data/repositories/status_repository.dart';
import 'package:clothes_control/features/clothes_detail/presentation/bloc/clothes_detail_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vibration/vibration.dart';

class ClothesDetailScreen extends StatelessWidget {
  final int? itemId;

  const ClothesDetailScreen({super.key, this.itemId});

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

  _navigateBack(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (ctx) => const ClothesListScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = ClothesDetailBloc(
          clothesRepository: ClothesRepository(databaseHelper: DatabaseHelper()),
          conditionRepository: ConditionRepository(databaseHelper: DatabaseHelper()),
          statusRepository: StatusRepository(databaseHelper: DatabaseHelper()),
          imageRepository: ImageRepository(),
        );
        if (itemId == null) {
          bloc.add(const LoadNewClothesDetailParams());
        } else {
          bloc.add(LoadClothesDetail(itemId: itemId!));
        }
        return bloc;
      },
      child: BlocListener<ClothesDetailBloc, ClothesDetailState>(
        listener: (context, state) async {
          if (itemId == null && state is ClothesDetailLoaded) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ClothesDetailScreen(itemId: state.cloth.id),
              ),
            );
          }
          if (state is ClothesDetailError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 3),
              ),
            );
            if (await Vibration.hasVibrator()) {
              Vibration.vibrate(duration: 100);
            }
          }
        },
        child: BlocBuilder<ClothesDetailBloc, ClothesDetailState>(
          builder: (context, state) {
            Cloth? cloth;
            List<Status>? statuses;
            List<Condition>? conditions;
            if (state is ClothesDetailLoaded) {
              cloth = state.cloth;
              statuses = state.statuses;
              conditions = state.conditions;
            }
            if (state is ClothesDetailParams4NewDetailLoaded) {
              statuses = state.statuses;
              conditions = state.conditions;
            }
            final title = itemId == null
                ? 'Новая вещь'
                : state is ClothesDetailLoaded
                    ? state.cloth.name
                    : '';
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    _navigateBack(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                actions: [
                  if (state is ClothesDetailLoaded)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<ClothesDetailBloc>().add(DeleteClothesItem(itemId: itemId!));
                        _navigateBack(context);
                      },
                    ),
                ],
              ),
              body: SingleChildScrollView(
                child: AbsorbPointer(
                  absorbing: state is ClothesDetailLoading,
                  child: Stack(
                    children: [
                      ClothesDetailForm(
                        cloth: cloth,
                        statuses: statuses,
                        conditions: conditions,
                        disabled: state is ClothesDetailLoading,
                        onSave: (newCloth) {
                          if (itemId == null) {
                            final cloth = NewClothDTO.fromMap(newCloth!);
                            print(cloth.toString());
                            context.read<ClothesDetailBloc>().add(AddNewClothesItem(item: cloth));
                          } else {
                            context.read<ClothesDetailBloc>().add(
                                  UpdateClothesItem(
                                    updatedItem: cloth!.copyWith(
                                      name: newCloth!['name'].toString(),
                                      description: newCloth['description'].toString(),
                                      statusId: (newCloth['status_id'] as num?)?.toInt(),
                                      conditionId: (newCloth['condition_id'] as num?)?.toInt(),
                                    ),
                                  ),
                                );
                          }
                        },
                      ),
                      // if (state is ClothesDetailLoading)
                      //   ModalBarrier(
                      //     color: Colors.black.withValues(alpha: 0.5),
                      //     dismissible: false,
                      //   ),
                      // if (state is ClothesDetailLoading)
                      //   const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
