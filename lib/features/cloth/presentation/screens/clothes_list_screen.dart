import 'dart:math';

import 'package:clothes_control/core/di/service_locator.dart';
import 'package:clothes_control/domain/entities/cloth.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';
import 'package:clothes_control/domain/repositories/clothes_repository.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';
import 'package:clothes_control/features/_shared/widgets/layout/custom_sliver_app_bar.dart';
import 'package:clothes_control/features/_shared/widgets/layout/custom_sliver_layout.dart';
import 'package:clothes_control/features/cloth/presentation/dto/clothes_list_filters_dto.dart';
import 'package:clothes_control/features/cloth/presentation/widgets/clothes_list_item.dart';
import 'package:clothes_control/features/_shared/widgets/ui/dropdown_select/ui_dropdown_select.dart';
import 'package:clothes_control/features/_shared/widgets/ui/text/ui_text_no_data.dart';
import 'package:clothes_control/core/router/extensions/app_router_navigation.dart';
import 'package:clothes_control/core/router/route_names.dart';
import 'package:clothes_control/core/utils/extensions/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/cloth/presentation/bloc/clothes_list/clothes_list_bloc.dart';

class ClothesListScreen extends StatelessWidget {
  ClothesListScreen({super.key});

  final _searchInputController = TextEditingController();

  _openDetailsPage(BuildContext context, {Cloth? cloth}) async {
    await context.pushNamedAppRoute(
      RouteNames.clothesDetail,
      pathParameters: {'id': cloth?.id.toString() ?? 'new'},
    );
    if (context.mounted) {
      context.read<ClothesListBloc>().add(const LoadClothesListEvent());
    }
  }

  Future _openFilters(BuildContext context) {
    final bloc = context.read<ClothesListBloc>();
    return showDialog(
      context: context,
      builder: (context) => BlocProvider.value(
        value: bloc,
        child: BlocBuilder<ClothesListBloc, ClothesListState>(
          builder: (context, state) {
            return Dialog(
              insetPadding: const EdgeInsets.all(16), // Отступы от краев экрана
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400), // Максимальная ширина
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // Занимаем только нужное место
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Фильтры',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      UiDropdownSelect<int>(
                        label: 'Статус',
                        value: state.filters.statusId,
                        items: state.statuses
                            .map((option) => DropdownMenuItem(
                                  value: option.id,
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: ColoredBox(
                                          color: HexColor.fromHex(option.color),
                                          child: const SizedBox(width: 20, height: 20),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(option.name),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          context.read<ClothesListBloc>().add(
                                LoadClothesListEvent(
                                  filters: ClothesListFiltersDTO(
                                    search: state.filters.search,
                                    statusId: value,
                                    categoryId: state.filters.categoryId,
                                  ),
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: 16),
                      UiDropdownSelect(
                        label: 'Категория',
                        value: state.filters.categoryId,
                        items: state.categories
                            .map((option) => DropdownMenuItem(
                                  value: option.id,
                                  child: Text(option.name),
                                ))
                            .toList(),
                        onChanged: (value) {
                          context.read<ClothesListBloc>().add(
                                LoadClothesListEvent(
                                  filters: ClothesListFiltersDTO(
                                    search: state.filters.search,
                                    statusId: state.filters.statusId,
                                    categoryId: value,
                                  ),
                                ),
                              );
                        },
                      ),
                      const SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              context.read<ClothesListBloc>().add(
                                    LoadClothesListEvent(
                                      filters: ClothesListFiltersDTO(
                                        search: state.filters.search,
                                        statusId: null,
                                        categoryId: null,
                                      ),
                                    ),
                                  );
                            },
                            child: const Text(
                              'Сбросить',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          const SizedBox(width: 24),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Закрыть'),
                          ),
                        ],
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

  Widget _buildBottomNavBar(BuildContext context) {
    final bloc = context.read<ClothesListBloc>();
    return BlocProvider.value(
      value: bloc,
      child: BlocBuilder<ClothesListBloc, ClothesListState>(
        builder: (context, state) {
          return Positioned(
            bottom: 12,
            right: 0,
            left: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: 0,
                    right: 12,
                    bottom: 0,
                    // bottom: 12 +
                    //     max(
                    //       0,
                    //       MediaQuery.of(context).viewInsets.bottom - kBottomNavigationBarHeight,
                    //     ),
                    left: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchInputController,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(Icons.search),
                            labelText: 'Поиск',
                            floatingLabelBehavior: FloatingLabelBehavior.never,
                            suffixIcon: !state.loading && state.filters.search != null
                                ? IconButton(
                                    onPressed: () {
                                      if (_searchInputController.text.isNotEmpty) {
                                        context
                                            .read<ClothesListBloc>()
                                            .add(const LoadClothesListEvent());
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      }
                                      _searchInputController.clear();
                                    },
                                    icon: const Icon(Icons.clear),
                                  )
                                : null,
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                width: 1,
                                style: BorderStyle.solid,
                                color: Colors.black38,
                              ),
                            ),
                            contentPadding: const EdgeInsets.all(8),
                          ),
                          maxLines: null,
                          onTapOutside: (event) => FocusManager.instance.primaryFocus?.unfocus(),
                          onChanged: (value) {
                            context.read<ClothesListBloc>().add(
                                  LoadClothesListEvent(
                                    filters: ClothesListFiltersDTO(
                                      search: value,
                                      statusId: state.filters.statusId,
                                      categoryId: state.filters.categoryId,
                                    ),
                                  ),
                                );
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _openFilters(context);
                        },
                        icon: Badge(
                          isLabelVisible: state.filtersCount > 0,
                          label: Text('${state.filtersCount}'),
                          child: const Icon(Icons.filter_list_sharp),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildContent(context) {
    return BlocBuilder<ClothesListBloc, ClothesListState>(
      builder: (context, state) {
        if (state.loading) {
          return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
        }
        if (state.clothes.isNotEmpty) {
          return SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final listItem = state.clothes[index];
                return ClothesListItem(
                  cloth: listItem.cloth,
                  status: listItem.status,
                  category: listItem.category,
                  onTap: () {
                    _openDetailsPage(context, cloth: listItem.cloth);
                  },
                  onDelete: () {
                    context
                        .read<ClothesListBloc>()
                        .add(DeleteClothesItemEvent(itemId: listItem.cloth.id));
                  },
                );
              }),
            ),
          );
        }
        if (state.error != null) {
          return SliverFillRemaining(child: Center(child: Text(state.error!)));
        }
        return const SliverFillRemaining(hasScrollBody: false, child: UiTextNoData());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClothesListBloc(
        clothesRepository: sl<IClothesRepository>(),
        statusRepository: sl<IStatusRepository>(),
        categoryRepository: sl<ICategoryRepository>(),
      )..add(const LoadClothesListEvent()),
      child: BlocBuilder<ClothesListBloc, ClothesListState>(
        builder: (context, state) {
          return CustomSliverLayout(
            appBar: const CustomSliverAppBar(
              titleText: 'Мой гардероб',
              // actions: [
              //   InkWell(
              //       onTap: () {
              //         context.pushNamedAppRoute(RouteNames.settings);
              //       },
              //       child: const Icon(Icons.settings, color: Colors.white)),
              // ],
            ),
            body: _buildContent(context),
            extraBottom: _buildBottomNavBar(context),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _openDetailsPage(context);
              },
              child: const Icon(Icons.add),
            ),
            floatingActionButtonBottom: 80,
          );
        },
      ),
    );
  }
}
