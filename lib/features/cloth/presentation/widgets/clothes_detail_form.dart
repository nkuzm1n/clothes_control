import 'package:clothes_control/core/data/dto/category/category_dto.dart';
import 'package:clothes_control/core/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/core/data/dto/status/status_dto.dart';
import 'package:clothes_control/shared/ui/button/ui_button.dart';
import 'package:clothes_control/shared/ui/image/ui_image.dart';
import 'package:clothes_control/shared/ui/snackbar/ui_snackbar.dart';
import 'package:clothes_control/core/utils/extensions/hex_color.dart';
import 'package:clothes_control/core/utils/helpers/image_helper.dart';
import 'package:clothes_control/core/utils/helpers/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class ClothesDetailForm extends StatefulWidget {
  final ClothDTO? cloth;
  final List<StatusDTO> statuses;
  final List<CategoryDTO> categories;
  final bool disabled;
  final bool loading;
  final Function(Map<String, Object?>? newCloth)? onSave;
  final Function(String url)? onImageLoad;
  final Function()? onStatusesPressed;
  final Function()? onCategoryPressed;

  const ClothesDetailForm({
    super.key,
    this.cloth,
    this.statuses = const [],
    this.categories = const [],
    this.disabled = false,
    this.loading = false,
    this.onSave,
    this.onImageLoad,
    this.onStatusesPressed,
    this.onCategoryPressed,
  });

  @override
  State<ClothesDetailForm> createState() => _ClothesDetailFormState();
}

class _ClothesDetailFormState extends State<ClothesDetailForm> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  String? _selectedImageUrl;
  int? _selectedStatusId;
  int? _selectedCategoryId;

  _updateClothFields() {
    _nameController = TextEditingController(text: widget.cloth?.name);
    _descriptionController = TextEditingController(text: widget.cloth?.description);
    _selectedStatusId = widget.cloth?.statusId;
    _selectedCategoryId = widget.cloth?.categoryId;
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
                        labelText: 'Категория',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      value: widget.cloth?.categoryId,
                      items: widget.categories.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Text(value.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                    ),
                  ),
                  // const SizedBox(width: 12),
                  // UiButton(
                  //   icon: const Icon(Icons.list, color: Colors.white),
                  //   borderRadius: BorderRadius.circular(1),
                  //   padding: const EdgeInsets.all(8),
                  //   width: 40,
                  //   onPressed: widget.onStatusesPressed,
                  // ),
                ],
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
                      items: widget.statuses.map((value) {
                        return DropdownMenuItem(
                          value: value.id,
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ColoredBox(
                                  color: HexColor.fromHex(value.color),
                                  child: const SizedBox(width: 20, height: 20),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(value.name),
                            ],
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedStatusId = value;
                        });
                      },
                    ),
                  ),
                  // const SizedBox(width: 12),
                  // UiButton(
                  //   icon: const Icon(Icons.list, color: Colors.white),
                  //   borderRadius: BorderRadius.circular(1),
                  //   padding: const EdgeInsets.all(8),
                  //   width: 40,
                  //   onPressed: widget.onStatusesPressed,
                  // ),
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (_nameController.text.isEmpty) {
                      UiSnackbar.show(
                        context,
                        'Поле "Наименование" не может быть пустым',
                        withVibration: true,
                      );
                      return;
                    }
                    if (widget.onSave != null) {
                      final clothData = {
                        'id': widget.cloth?.id,
                        'name': _nameController.text,
                        'description': _descriptionController.text.trim(),
                        'status_id': _selectedStatusId,
                        'category_id': _selectedCategoryId,
                        'image_url': _selectedImageUrl,
                      };
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
