import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:clothes_control/shared/domain/services/cloth_service.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/image/ui_image.dart';
import 'package:clothes_control/shared/utils/image.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ClothesDetailForm extends StatelessWidget {
  final Cloth? cloth;
  final List<Condition> conditions;
  final List<Status> statuses;
  final bool disabled;
  final bool loading;
  final Function(Map<String, Object?>? newCloth)? onSave;
  final Function(String url)? onImageLoad;

  const ClothesDetailForm({
    super.key,
    this.cloth,
    conditions,
    statuses,
    this.disabled = false,
    this.loading = false,
    this.onSave,
    this.onImageLoad,
  })  : conditions = conditions ?? const [],
        statuses = statuses ?? const [];

  void _openAddStatusBottomSheet(
    BuildContext context,
    String label,
    String buttonText,
  ) {
    final statusController = TextEditingController(text: cloth?.name);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: statusController,
                  decoration: InputDecoration(
                    labelText: label,
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (statusController.text.isNotEmpty) {
                      statusController.clear();
                      Navigator.pop(context);
                    }
                  },
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController(text: cloth?.name);
    final descriptionController = TextEditingController(text: cloth?.description);
    int? selectedStatusId = cloth?.statusId;
    int? selectedConditionId = cloth?.conditionId;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          DropdownButtonFormField<int>(
            value: cloth?.statusId,
            items: statuses.map((status) {
              return DropdownMenuItem(
                value: status.id,
                child: Text(status.name),
              );
            }).toList(),
            onChanged: (value) {
              selectedStatusId = value;
            },
            decoration: const InputDecoration(labelText: 'Статус'),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            value: cloth?.conditionId,
            items: conditions.map((condition) {
              return DropdownMenuItem(
                value: condition.id,
                child: Text(condition.name),
              );
            }).toList(),
            decoration: const InputDecoration(labelText: 'Состояние'),
            onChanged: (value) {
              selectedConditionId = value;
            },
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiImage(
                image: ImageHelper.networkImageOrNull(cloth?.imageUrl),
                width: 140,
                height: 140,
                fit: BoxFit.cover,
              ),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (onImageLoad != null) {
                      const url = '';
                      // TODO:
                      onImageLoad!(url);
                    }
                  },
                  child: const Text('Загрузить'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Поле "Наименование" не может быть пустым'),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  if (await Vibration.hasVibrator()) {
                    Vibration.vibrate(duration: 100);
                  }
                  return;
                }
                if (onSave != null) {
                  final newCloth = {
                    'name': nameController.text,
                    'description': descriptionController.text,
                    'condition_id': selectedConditionId,
                    'status_id': selectedStatusId,
                  };

                  onSave!(newCloth);
                }
              },
              child: const Text('Сохранить'),
            ),
          ),
        ],
      ),
    );
  }
}
