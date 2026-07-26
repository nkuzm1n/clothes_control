import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/data/dto/cloth/new_cloth_dto.dart';
import 'package:clothes_control/data/repositories/category_repository.dart';
import 'package:clothes_control/shared/widgets/ui/snackbar/ui_snackbar.dart';
import 'package:clothes_control/core/utils/navigation/navigation.dart';
import 'package:clothes_control/features/cloth/presentation/widgets/clothes_detail_form.dart';
import 'package:clothes_control/data/local/database_helper.dart';
import 'package:clothes_control/data/repositories/clothes_repository.dart';
import 'package:clothes_control/data/repositories/image_repository.dart';
import 'package:clothes_control/data/repositories/status_repository.dart';
import 'package:clothes_control/features/cloth/presentation/blocs/clothes_detail/clothes_detail_bloc.dart';

class ClothesDetailScreen extends StatelessWidget {
  final ClothDTO? cloth;

  const ClothesDetailScreen({super.key, this.cloth});

  _navigateBack(BuildContext context) {
    AppNavigation.pop(context);
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
            clothesRepository: ClothesRepositoryImpl(databaseHelper: DatabaseHelper()),
            statusRepository: StatusRepositoryImpl(databaseHelper: DatabaseHelper()),
            categoryRepository: CategoryRepositoryImpl(databaseHelper: DatabaseHelper()),
            imageRepository: ImageRepositoryImpl(),
          );
          bloc.add(
            LoadClothesDetailEvent(cloth: cloth, statuses: const [], categories: const []),
          );
          return bloc;
        },
        child: BlocConsumer<ClothesDetailBloc, ClothesDetailState>(
          listener: (context, state) async {
            if (state is ClothesDetailDeletedState ||
                state is ClothesDetailUpdatedState ||
                state is ClothesDetailAddedState) {
              _navigateBack(context);
            }
            if (state is ClothesDetailErrorState) {
              await UiSnackbar.show(context, state.error?.message);
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    _navigateBack(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                ),
                title: Text(
                  state.clothName ?? 'Новая вещь',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                actions: [
                  if (state.cloth != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<ClothesDetailBloc>().add(
                              DeleteClothesItemEvent(
                                cloth: cloth!,
                                statuses: state.statuses,
                                categories: state.categories,
                              ),
                            );
                      },
                    ),
                ],
              ),
              body: SingleChildScrollView(
                child: AbsorbPointer(
                  absorbing: state is ClothesDetailLoadingState,
                  child: Stack(
                    children: [
                      ClothesDetailForm(
                        cloth: cloth,
                        statuses: state.statuses,
                        categories: state.categories,
                        disabled: state is ClothesDetailLoadingState,
                        loading: state is ClothesDetailLoadingState,
                        onSave: (newCloth) {
                          if (cloth == null) {
                            context.read<ClothesDetailBloc>().add(
                                  AddNewClothEvent(
                                    newCloth: NewClothDTO.fromMap(newCloth!),
                                    statuses: state.statuses,
                                    categories: state.categories,
                                  ),
                                );
                          } else {
                            context.read<ClothesDetailBloc>().add(
                                  UpdateClothesDetailEvent(
                                    cloth: ClothDTO(
                                      id: (newCloth!['id'] as num).toInt(),
                                      name: newCloth['name'].toString(),
                                      description: newCloth['description']?.toString(),
                                      statusId: (newCloth['status_id'] as num?)?.toInt(),
                                      categoryId: (newCloth['category_id'] as num?)?.toInt(),
                                      imageUrl: newCloth['image_url']?.toString(),
                                    ),
                                    statuses: state.statuses,
                                    categories: state.categories,
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
    );
  }
}
