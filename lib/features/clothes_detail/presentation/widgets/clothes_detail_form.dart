import 'package:clothes_control/shared/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/status/status_dto.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/button/ui_button.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/image/ui_image.dart';
import 'package:clothes_control/shared/utils/helpers/image_helper.dart';
import 'package:clothes_control/shared/utils/helpers/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ClothesDetailForm extends StatefulWidget {
  final ClothDTO? cloth;
  final List<StatusDTO> statuses;
  final bool disabled;
  final bool loading;
  final Function(Map<String, Object?>? newCloth)? onSave;
  final Function(String url)? onImageLoad;
  final Function()? onStatusesPressed;

  const ClothesDetailForm({
    super.key,
    this.cloth,
    statuses,
    this.disabled = false,
    this.loading = false,
    this.onSave,
    this.onImageLoad,
    this.onStatusesPressed,
  }) : statuses = statuses ?? const [];

  @override
  State<ClothesDetailForm> createState() => _ClothesDetailFormState();
}

class _ClothesDetailFormState extends State<ClothesDetailForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _selectedImageUrl;
  int? _selectedStatusId;

  _updateClothFields() {
    _nameController = TextEditingController(text: widget.cloth?.name);
    _descriptionController = TextEditingController(text: widget.cloth?.description);
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
                image: ImageHelper.fileImageOrNull(_selectedImageUrl),
                width: double.infinity,
                height: 380,
                fit: BoxFit.cover,
                loading: widget.loading,
              ),
              if (!widget.loading)
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
              if (!widget.loading && _selectedImageUrl != null)
                Positioned(
                  top: 16,
                  right: 16,
                  child: UiButton(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    borderRadius: BorderRadius.circular(24),
                    padding: const EdgeInsets.all(4),
                    width: 34,
                    onPressed: () {
                      setState(() {
                        _selectedImageUrl = null;
                      });
                    },
                    child: Icon(Icons.close, color: Theme.of(context).colorScheme.primary),
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
                decoration: const InputDecoration(
                  labelText: 'Наименование',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                style: const TextStyle(fontWeight: FontWeight.bold),
                maxLines: null,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Описание',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
                maxLines: null,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Flexible(
                    child: DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Статус',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
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
                    ),
                  ),
                  const SizedBox(width: 12),
                  UiButton(
                    icon: const Icon(Icons.list, color: Colors.white),
                    borderRadius: BorderRadius.circular(1),
                    padding: const EdgeInsets.all(8),
                    width: 40,
                    onPressed: widget.onStatusesPressed,
                  ),
                ],
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
                      final clothData = {
                        'id': widget.cloth?.id,
                        'name': _nameController.text,
                        'description': _descriptionController.text.trim(),
                        'status_id': _selectedStatusId,
                        'image_url': _selectedImageUrl ?? widget.cloth?.imageUrl,
                      };
                      print(clothData);
                      widget.onSave!(clothData);
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
