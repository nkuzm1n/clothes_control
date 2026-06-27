import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/core/data/dto/status/new_status_dto.dart';
import 'package:clothes_control/core/data/dto/status/status_dto.dart';
import 'package:clothes_control/shared/navigation/navigation_bar.dart';
import 'package:clothes_control/shared/ui/colorpicker/ui_colorpicker.dart';
import 'package:clothes_control/core/utils/extensions/hex_color.dart';
import 'package:clothes_control/core/utils/navigation/navigation.dart';
import 'package:clothes_control/core/data/bloc/status/status_bloc.dart';
import 'package:clothes_control/core/data/local/database_helper.dart';
import 'package:clothes_control/core/data/repositories/status_repository.dart';

class StatusesDetailScreen extends StatelessWidget {
  final StatusDTO? status;

  const StatusesDetailScreen({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = StatusBloc(
          statusRepository: StatusRepositoryImpl(
            databaseHelper: DatabaseHelper(),
          ),
        );
        if (status != null) {
          bloc.add(LoadStatusEvent(status: status!));
        }
        return bloc;
      },
      child: StatusesDetailView(status: status),
    );
  }
}

class StatusesDetailView extends StatelessWidget {
  final StatusDTO? status;

  const StatusesDetailView({super.key, this.status});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatusBloc, StatusState>(
      listener: (context, state) {
        if (state is CreatedStatusState || state is UpdatedStatusState) {
          return AppNavigation.pop(context);
        }
      },
      builder: (context, state) {
        final formKey = GlobalKey<FormState>();
        final nameController = TextEditingController(
          text: state.statusName,
        );
        var pickedColor = state.statusColor == null
            ? UiColorpicker.defaultColors[0]
            : HexColor.fromHex(state.status?.color);
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => AppNavigation.pop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              title: Text(
                state.statusName == null ? 'Новый статус' : state.statusName!,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Заполните поле';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                            labelText: 'Наименование *',
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                          ),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Text('Цвет:'),
                            const SizedBox(width: 24),
                            UiColorpicker(
                              currentColor: pickedColor,
                              onColorChanged: (color) {
                                pickedColor = color;
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        if (state.status == null) {
                          context.read<StatusBloc>().add(
                                AddNewStatusEvent(
                                  newStatus: NewStatusDTO(
                                    name: nameController.text,
                                    color: pickedColor.toHex(),
                                  ),
                                ),
                              );
                        } else {
                          context.read<StatusBloc>().add(
                                UpdateStatusEvent(
                                  status: status!.copyWith(
                                    name: nameController.text,
                                    color: pickedColor.toHex(),
                                  ),
                                ),
                              );
                        }
                      }
                    },
                    child: const Text('Сохранить'),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: AppNavigationBar(currentIndex: 2),
          ),
        );
      },
    );
  }
}
