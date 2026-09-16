import 'package:clothes_control/core/di/service_locator.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/domain/repositories/params/status/create_status_params.dart';
import 'package:clothes_control/presentation/_shared/widgets/ui/colorpicker/ui_colorpicker.dart';
import 'package:clothes_control/core/utils/extensions/hex_color.dart';
import 'package:clothes_control/presentation/_shared/bloc/status/status_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:clothes_control/presentation/_shared/widgets/layout/custom_sliver_layout.dart';
import 'package:clothes_control/presentation/_shared/widgets/layout/custom_sliver_app_bar.dart';

class StatusesDetailScreen extends StatelessWidget {
  final int? id;

  const StatusesDetailScreen({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = StatusBloc(statusRepository: sl<IStatusRepository>());
        if (id != null) {
          bloc.add(LoadStatusEvent(id: id!));
        }
        return bloc;
      },
      child: StatusesDetailView(id: id),
    );
  }
}

class StatusesDetailView extends StatelessWidget {
  final int? id;

  const StatusesDetailView({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatusBloc, StatusState>(
      listener: (context, state) {
        if (state is CreatedStatusState || state is UpdatedStatusState) {
          context.pop();
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
          child: CustomSliverLayout(
            appBar: CustomSliverAppBar(
              leading: IconButton(
                onPressed: () => context.pop(),
                icon: const Icon(Icons.arrow_back, color: Colors.white),
              ),
              titleText: state.statusName ?? 'Новый статус',
            ),
            body: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  spacing: 30,
                  children: [
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
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
                        if (formKey.currentState?.validate() ?? false) {
                          if (state.status == null) {
                            context.read<StatusBloc>().add(
                                  AddNewStatusEvent(
                                    newStatus: CreateStatusParams(
                                      name: nameController.text,
                                      color: pickedColor.toHex(),
                                    ),
                                  ),
                                );
                          } else {
                            context.read<StatusBloc>().add(
                                  UpdateStatusEvent(
                                    status: state.status!.copyWith(
                                      name: state.status!.name,
                                      color: state.status!.color,
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
            ),
          ),
        );
      },
    );
  }
}
