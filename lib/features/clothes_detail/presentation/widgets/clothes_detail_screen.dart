import 'dart:io';
import 'package:clothes_control/shared/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/shared/domain/entities/cloth.dart';
import 'package:clothes_control/shared/domain/entities/condition.dart';
import 'package:clothes_control/shared/domain/entities/status.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/clothes_detail/presentation/widgets/clothes_detail_form.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/data/repositories/clothes_repository.dart';
import 'package:clothes_control/shared/data/repositories/condition_repository.dart';
import 'package:clothes_control/shared/data/repositories/image_repository.dart';
import 'package:clothes_control/shared/data/repositories/status_repository.dart';
import 'package:clothes_control/features/clothes_detail/presentation/bloc/clothes_detail_bloc.dart';
import 'package:vibration/vibration.dart';

class ClothesDetailScreen extends StatelessWidget {
  final int? itemId;

  const ClothesDetailScreen({super.key, this.itemId});

  _navigateBack(BuildContext context) {
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
          final bloc = ClothesDetailBloc(
            clothesRepository: ClothesRepository(databaseHelper: DatabaseHelper()),
            conditionRepository: ConditionRepository(databaseHelper: DatabaseHelper()),
            statusRepository: StatusRepositoryImpl(databaseHelper: DatabaseHelper()),
            imageRepository: ImageRepository(),
          );
          if (itemId == null) {
            bloc.add(const InitEmptyClothesDetail());
          } else {
            bloc.add(LoadClothesDetail(itemId: itemId!));
          }
          return bloc;
        },
        child: BlocListener<ClothesDetailBloc, ClothesDetailState>(
          listener: (context, state) async {
            if (state is ClothesItemDeleted || state is ClothesItemUpdated) {
              _navigateBack(context);
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
              if (state is ClothesDetailLoading) {
                cloth = state.cloth;
                statuses = state.statuses;
                conditions = state.conditions;
              }
              if (state is EmptyClothesDetailLoaded) {
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
                body: BlocBuilder<ClothesDetailBloc, ClothesDetailState>(
                  buildWhen: (previous, current) {
                    return current is ClothesDetailLoading ||
                        current is ClothesDetailLoaded ||
                        current is EmptyClothesDetailLoaded;
                  },
                  builder: (context, state) {
                    return SingleChildScrollView(
                      child: AbsorbPointer(
                        absorbing: state is ClothesDetailLoading,
                        child: Stack(
                          children: [
                            ClothesDetailForm(
                              cloth: cloth,
                              statuses: statuses,
                              conditions: conditions,
                              disabled: state is ClothesDetailLoading,
                              loading: state is ClothesDetailLoading,
                              onSave: (newCloth) {
                                if (itemId == null) {
                                  final cloth = NewClothDTO.fromMap(newCloth!);
                                  print(cloth.toString());
                                  context.read<ClothesDetailBloc>().add(AddNewCloth(item: cloth));
                                } else {
                                  context.read<ClothesDetailBloc>().add(
                                        UpdateClothesItem(
                                          updatedItem: cloth!.copyWith(
                                            name: newCloth!['name'].toString(),
                                            description: newCloth['description'].toString(),
                                            statusId: (newCloth['status_id'] as num?)?.toInt(),
                                            conditionId:
                                                (newCloth['condition_id'] as num?)?.toInt(),
                                            imageUrl: newCloth['image_url'].toString(),
                                          ),
                                          conditions: conditions,
                                          statuses: statuses,
                                        ),
                                      );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
