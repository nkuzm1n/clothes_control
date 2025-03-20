import 'package:clothes_control/features/clothes_detail/presentation/bloc/clothes_detail_bloc.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/image/ui_image.dart';
import 'package:clothes_control/shared/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ClothesDetailForm extends StatelessWidget {
  final Cloth cloth;

  const ClothesDetailForm({super.key, required this.cloth});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClothesDetailBloc, ClothesDetailState>(
      buildWhen: (previous, current) => current is ClothesDetailLoaded,
      builder: (context, state) {
        final state = context.read<ClothesDetailBloc>().state;

        final inputDisabled = state is ClothesDetailLoading;

        final nameController = TextEditingController(text: cloth.name);
        final descriptionController = TextEditingController(text: cloth.description);
        final statusController = TextEditingController(text: cloth.status?.name);
        final conditionController = TextEditingController(text: cloth.condition?.name);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Наименование'),
                readOnly: inputDisabled,
                maxLines: null,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                readOnly: inputDisabled,
                maxLines: null,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Статус'),
                readOnly: inputDisabled,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: conditionController,
                decoration: const InputDecoration(labelText: 'Состояние'),
                readOnly: inputDisabled,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiImage(
                    image: ImageHelper.networkImageOrNull(cloth.imageUrl),
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        // final String? url = await uploadImageAndSaveLocally();
                        // print("URL OF PHOTO IS $url");
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
                    //   id: cloth.id,
                    //   name: nameController.text,
                    //   description: descriptionController.text,
                    //   condition: conditionController.text,
                    //   status: statusController.text,
                    //   imageUrl: cloth.imageUrl,
                    // );
                    // context.read<ClothesDetailBloc>().add(UpdateCloth(updatedItem: updatedItem));
                  },
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
