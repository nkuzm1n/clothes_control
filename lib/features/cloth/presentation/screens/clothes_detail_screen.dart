import 'package:clothes_control/core/di/service_locator.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';
import 'package:clothes_control/domain/repositories/clothes_repository.dart';
import 'package:clothes_control/domain/repositories/image_repository.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/_shared/widgets/ui/snackbar/ui_snackbar.dart';
import 'package:clothes_control/features/cloth/presentation/widgets/clothes_detail_form.dart';
import 'package:clothes_control/features/cloth/presentation/bloc/clothes_detail/clothes_detail_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:clothes_control/features/_shared/widgets/layout/sliver_page_layout.dart';
import 'package:clothes_control/features/_shared/widgets/layout/primary_sliver_app_bar.dart';

class ClothesDetailScreen extends StatelessWidget {
  final int? id;

  const ClothesDetailScreen({super.key, this.id});

  _navigateBack(BuildContext context) {
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClothesDetailBloc(
        clothesRepository: sl<IClothesRepository>(),
        statusRepository: sl<IStatusRepository>(),
        categoryRepository: sl<ICategoryRepository>(),
        imageRepository: sl<IImageRepository>(),
      )..add(
          LoadClothesDetailEvent(id: id, statuses: const [], categories: const []),
        ),
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
          return GestureDetector(
            onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
            child: SliverPageLayout(
              sliverAppBar: PrimarySliverAppBar(
                leading: IconButton(
                  onPressed: () => _navigateBack(context),
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                ),
                titleText: state.clothName ?? 'Новая вещь',
                actions: [
                  if (state.cloth != null)
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        context.read<ClothesDetailBloc>().add(
                              DeleteClothesItemEvent(
                                id: id!,
                                statuses: state.statuses,
                                categories: state.categories,
                              ),
                            );
                      },
                    ),
                ],
              ),
              sliverBody: SliverToBoxAdapter(
                child: AbsorbPointer(
                  absorbing: state is ClothesDetailLoadingState,
                  child: Stack(
                    children: [
                      ClothesDetailForm(
                        cloth: state.cloth,
                        statuses: state.statuses,
                        categories: state.categories,
                        disabled: state is ClothesDetailLoadingState,
                        loading: state is ClothesDetailLoadingState,
                        onSave: (newCloth) {
                          if (id == null) {
                            context.read<ClothesDetailBloc>().add(
                                  AddNewClothEvent(
                                    newCloth: newCloth,
                                    statuses: state.statuses,
                                    categories: state.categories,
                                  ),
                                );
                          } else {
                            context.read<ClothesDetailBloc>().add(
                                  UpdateClothesDetailEvent(
                                    cloth: state.cloth!.copyWith(
                                      name: newCloth.name,
                                      description: newCloth.description,
                                      statusId: newCloth.statusId,
                                      categoryId: newCloth.categoryId,
                                      imageUrl: newCloth.imageUrl,
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
            ),
          );
        },
      ),
    );
  }
}
