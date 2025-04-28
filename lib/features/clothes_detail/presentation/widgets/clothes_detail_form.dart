import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/image/ui_image.dart';
import 'package:clothes_control/shared/utils/helpers/image_helper.dart';
import 'package:clothes_control/shared/utils/helpers/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ClothesDetailForm extends StatefulWidget {
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

  @override
  State<ClothesDetailForm> createState() => _ClothesDetailFormState();
}

class _ClothesDetailFormState extends State<ClothesDetailForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _selectedImageUrl;
  int? _selectedConditionId;
  int? _selectedStatusId;

  _updateClothFields() {
    _nameController = TextEditingController(text: widget.cloth?.name);
    _descriptionController = TextEditingController(text: widget.cloth?.description);
    _selectedConditionId = widget.cloth?.conditionId;
    _selectedStatusId = widget.cloth?.statusId;
  }

  @override
  void initState() {
    super.initState();
    _selectedImageUrl = widget.cloth?.imageUrl;
    _updateClothFields();
  }

  @override
  void didUpdateWidget(ClothesDetailForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      if (widget.cloth?.imageUrl != oldWidget.cloth?.imageUrl) {
        _selectedImageUrl = null;
      }
      _updateClothFields();
    });
  }

  Future<void> _pickImage() async {
    final image = await ImagePickerHelper.pickImageFromCamera();
    if (image != null) {
      setState(() {
        _selectedImageUrl = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          // borderRadius: BorderRadius.circular(12),
          child: Stack(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              UiImage(
                image: ImageHelper.fileImageOrNull(
                  _selectedImageUrl ?? widget.cloth?.imageUrl,
                ),
                width: double.infinity,
                height: 380,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      _pickImage();
                    },
                    child: widget.cloth?.imageUrl == null
                        ? const Text('Загрузить')
                        : const Text('Изменить'),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Наименование'),
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: null,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Описание'),
                maxLines: null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: widget.cloth?.statusId,
                items: widget.statuses.map((status) {
                  return DropdownMenuItem(
                    value: status.id,
                    child: Text(status.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatusId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Статус'),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<int>(
                value: widget.cloth?.conditionId,
                items: widget.conditions.map((condition) {
                  return DropdownMenuItem(
                    value: condition.id,
                    child: Text(condition.name),
                  );
                }).toList(),
                decoration: const InputDecoration(labelText: 'Состояние'),
                onChanged: (value) {
                  setState(() {
                    _selectedConditionId = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty) {
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
                    if (widget.onSave != null) {
                      final newCloth = {
                        'name': _nameController.text,
                        'description': _descriptionController.text,
                        'condition_id': _selectedConditionId,
                        'status_id': _selectedStatusId,
                        'image_url': _selectedImageUrl ?? widget.cloth?.imageUrl,
                      };
                      print(newCloth);
                      widget.onSave!(newCloth);
                    }
                  },
                  child: const Text('Сохранить'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// class ClothesDetailForm extends StatelessWidget {
//   final Cloth? cloth;
//   final List<Condition> conditions;
//   final List<Status> statuses;
//   final bool disabled;
//   final bool loading;
//   final Function(Map<String, Object?>? newCloth)? onSave;
//   final Function(String url)? onImageLoad;

//   const ClothesDetailForm({
//     super.key,
//     this.cloth,
//     conditions,
//     statuses,
//     this.disabled = false,
//     this.loading = false,
//     this.onSave,
//     this.onImageLoad,
//   })  : conditions = conditions ?? const [],
//         statuses = statuses ?? const [];

//   void _openAddStatusBottomSheet(
//     BuildContext context,
//     String label,
//     String buttonText,
//   ) {
//     final statusController = TextEditingController(text: cloth?.name);
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       enableDrag: true,
//       builder: (context) {
//         return Padding(
//           padding: EdgeInsets.only(
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Container(
//             padding: const EdgeInsets.all(20),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 TextField(
//                   controller: statusController,
//                   decoration: InputDecoration(
//                     labelText: label,
//                     border: const OutlineInputBorder(),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     if (statusController.text.isNotEmpty) {
//                       statusController.clear();
//                       Navigator.pop(context);
//                     }
//                   },
//                   child: Text(buttonText),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final nameController = TextEditingController(text: cloth?.name);
//     final descriptionController = TextEditingController(text: cloth?.description);
//     int? selectedStatusId = cloth?.statusId;
//     int? selectedConditionId = cloth?.conditionId;
//     String? selectedImageUrl = cloth?.imageUrl;

//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.circular(12),
//             child: Stack(
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 UiImage(
//                   image: selectedImageUrl == null
//                       ? ImageHelper.fileImageOrNull(cloth?.imageUrl)
//                       : ImageHelper.fileImageOrNull(selectedImageUrl),
//                   width: double.infinity,
//                   height: 240,
//                   fit: BoxFit.cover,
//                 ),
//                 Positioned(
//                   bottom: 10,
//                   left: 0,
//                   right: 0,
//                   child: Center(
//                     child: cloth?.imageUrl == null
//                         ? ElevatedButton(
//                             onPressed: () async {
//                               final image = await ImagePickerHelper.pickImageFromCamera();
//                               if (image != null) {
//                                 selectedImageUrl = image.path;
//                               }
//                             },
//                             child: const Text('Загрузить'),
//                           )
//                         : ElevatedButton(
//                             onPressed: () async {
//                               final image = await ImagePickerHelper.pickImageFromCamera();
//                               if (image != null) {
//                                 selectedImageUrl = image.path;
//                               }
//                             },
//                             child: const Text('Изменить'),
//                           ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: nameController,
//             decoration: const InputDecoration(labelText: 'Наименование'),
//             maxLines: null,
//           ),
//           const SizedBox(height: 8),
//           TextField(
//             controller: descriptionController,
//             decoration: const InputDecoration(labelText: 'Описание'),
//             maxLines: null,
//           ),
//           const SizedBox(height: 8),
//           DropdownButtonFormField<int>(
//             value: cloth?.statusId,
//             items: statuses.map((status) {
//               return DropdownMenuItem(
//                 value: status.id,
//                 child: Text(status.name),
//               );
//             }).toList(),
//             onChanged: (value) {
//               selectedStatusId = value;
//             },
//             decoration: const InputDecoration(labelText: 'Статус'),
//           ),
//           const SizedBox(height: 8),
//           DropdownButtonFormField<int>(
//             value: cloth?.conditionId,
//             items: conditions.map((condition) {
//               return DropdownMenuItem(
//                 value: condition.id,
//                 child: Text(condition.name),
//               );
//             }).toList(),
//             decoration: const InputDecoration(labelText: 'Состояние'),
//             onChanged: (value) {
//               selectedConditionId = value;
//             },
//           ),
//           const SizedBox(height: 16),
//           Center(
//             child: ElevatedButton(
//               onPressed: () async {
//                 if (nameController.text.isEmpty) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Поле "Наименование" не может быть пустым'),
//                       duration: Duration(seconds: 3),
//                     ),
//                   );
//                   if (await Vibration.hasVibrator()) {
//                     Vibration.vibrate(duration: 100);
//                   }
//                   return;
//                 }
//                 if (onSave != null) {
//                   final newCloth = {
//                     'name': nameController.text,
//                     'description': descriptionController.text,
//                     'condition_id': selectedConditionId,
//                     'status_id': selectedStatusId,
//                     'image_url': selectedImageUrl,
//                   };

//                   onSave!(newCloth);
//                 }
//               },
//               child: const Text('Сохранить'),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
