import 'dart:io';
import 'package:clothes_control/shared/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/shared/data/dto/status/status_dto.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/modal/swipeable_modal.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/snackbar/ui_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/clothes_detail/presentation/widgets/clothes_detail_form.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/data/repositories/clothes_repository.dart';
import 'package:clothes_control/shared/data/repositories/image_repository.dart';
import 'package:clothes_control/shared/data/repositories/status_repository.dart';
import 'package:clothes_control/features/clothes_detail/presentation/bloc/clothes_detail_bloc.dart';
import 'package:vibration/vibration.dart';

class ClothesDetailScreen extends StatelessWidget {
  final int? itemId;

  const ClothesDetailScreen({super.key, this.itemId});

  _navigateBack(BuildContext context) {
    print("NAVIFGARW BACK");
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: BlocProvider(
        create: (context) {
          return ClothesDetailBloc(
            clothesRepository: ClothesRepositoryImpl(databaseHelper: DatabaseHelper()),
            statusRepository: StatusRepositoryImpl(databaseHelper: DatabaseHelper()),
            imageRepository: ImageRepositoryImpl(),
          )..add(LoadClothesDetail(itemId: itemId));
        },
        child: BlocListener<ClothesDetailBloc, ClothesDetailState>(
          listener: (context, state) async {
            if (state is ClothesDetailDeleted ||
                state is ClothesDetailUpdated ||
                state is ClothesDetailAdded) {
              print("STATEWE SI S S SIIISISIS");
              _navigateBack(context);
            }
            if (state is ClothesDetailError) {
              await UiSnackbar.show(context, state.message);
            }
          },
          child: BlocBuilder<ClothesDetailBloc, ClothesDetailState>(
            builder: (context, state) {
              ClothDTO? cloth;
              List<StatusDTO>? statuses;
              if (state is ClothesDetailLoading) {
                cloth = state.cloth;
                statuses = state.statuses;
              }
              if (state is ClothesDetailLoaded) {
                cloth = state.cloth;
                statuses = state.statuses;
              }
              if (state is ClothesDetailUpdated) {
                cloth = state.cloth;
                statuses = state.statuses;
              }
              if (state is ClothesDetailDeleted) {
                cloth = state.cloth;
                statuses = state.statuses;
              }
              final title = itemId == null ? 'Новая вещь' : cloth?.name;
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    onPressed: () {
                      _navigateBack(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  title: Text(title ?? '', style: const TextStyle(fontWeight: FontWeight.w700)),
                  actions: [
                    if (cloth != null && state is ClothesDetailLoaded)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () {
                          context.read<ClothesDetailBloc>().add(
                                DeleteClothesItem(cloth: cloth!, statuses: statuses),
                              );
                        },
                      ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: AbsorbPointer(
                    absorbing: state is ClothesDetailLoading,
                    child: Stack(
                      children: [
                        if (statuses != null)
                          ClothesDetailForm(
                            cloth: cloth,
                            statuses: statuses,
                            disabled: state is ClothesDetailLoading,
                            loading: state is ClothesDetailLoading,
                            onSave: (newCloth) {
                              if (itemId == null) {
                                final cloth = NewClothDTO.fromMap(newCloth!);
                                print(cloth.toString());
                                context.read<ClothesDetailBloc>().add(
                                      AddNewCloth(
                                        cloth: cloth,
                                        statuses: statuses,
                                      ),
                                    );
                              } else {
                                context.read<ClothesDetailBloc>().add(
                                      UpdateClothesDetail(
                                        cloth: ClothDTO(
                                          id: (newCloth!['id'] as num).toInt(),
                                          name: newCloth['name'].toString(),
                                          description: newCloth['description']?.toString(),
                                          statusId: (newCloth['status_id'] as num?)?.toInt(),
                                          imageUrl: newCloth['image_url']?.toString(),
                                        ),
                                        statuses: statuses,
                                      ),
                                    );
                              }
                            },
                            onStatusesPressed: () async {
                              await UiSnackbar.show(
                                context,
                                'Функционал в данный момент в разработке',
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
