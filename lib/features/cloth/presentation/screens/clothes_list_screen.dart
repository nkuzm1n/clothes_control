import 'dart:math';

import 'package:clothes_control/features/cloth/presentation/dto/clothes_list_filters_dto.dart';
import 'package:clothes_control/features/cloth/presentation/widgets/clothes_list_item.dart';
import 'package:clothes_control/features/settings/presentation/screens/settings_screen.dart';
import 'package:clothes_control/core/data/dto/category/category_dto.dart';
import 'package:clothes_control/core/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/core/data/dto/status/status_dto.dart';
import 'package:clothes_control/core/data/local/database_helper.dart';
import 'package:clothes_control/core/data/repositories/category_repository.dart';
import 'package:clothes_control/core/data/repositories/clothes_repository.dart';
import 'package:clothes_control/core/data/repositories/status_repository.dart';
import 'package:clothes_control/shared/navigation/navigation_bar.dart';
import 'package:clothes_control/shared/ui/dropdown_select/ui_dropdown_select.dart';
import 'package:clothes_control/shared/ui/text/ui_text_no_data.dart';
import 'package:clothes_control/core/utils/extensions/hex_color.dart';
import 'package:clothes_control/core/utils/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/cloth/presentation/blocs/clothes_list/clothes_list_bloc.dart';
import 'package:clothes_control/features/cloth/presentation/screens/clothes_detail_screen.dart';

class ClothesListScreen extends StatelessWidget {
  ClothesListScreen({super.key});

  final _searchInputController = TextEditingController();

  _openDetailsPage(BuildContext context, {ClothDTO? cloth}) async {
    await AppNavigation.push(context, ClothesDetailScreen(cloth: cloth));
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
                        items: [
                          // StatusDTO(id: -1, name: 'Без статуса', color: Colors.transparent.toHex()),
                          ...state.statuses
                        ]
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
                        items: [
                          // const CategoryDTO(id: -1, name: 'Без категории'),
                          ...state.categories,
                        ]
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
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 0,
                  right: 12,
                  bottom: 12 +
                      max(
                        0,
                        MediaQuery.of(context).viewInsets.bottom - kBottomNavigationBarHeight,
                      ),
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
              AppNavigationBar(currentIndex: 0),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClothesListBloc(
        clothesRepository: ClothesRepositoryImpl(databaseHelper: DatabaseHelper()),
        statusRepository: StatusRepositoryImpl(databaseHelper: DatabaseHelper()),
        categoryRepository: CategoryRepositoryImpl(databaseHelper: DatabaseHelper()),
      )..add(const LoadClothesListEvent()),
      child: BlocBuilder<ClothesListBloc, ClothesListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              scrolledUnderElevation: 0,
              title: const Text(
                'Мой гардероб',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              actionsPadding: const EdgeInsets.only(right: 18),
              actions: [
                InkWell(
                  onTap: () {
                    AppNavigation.push(context, const SettingsScreen());
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.settings),
                  ),
                ),
              ],
              // backgroundColor: Colors.green.shade200,
            ),
            // backgroundColor: Colors.green.shade200,
            body: BlocBuilder<ClothesListBloc, ClothesListState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.clothes.isNotEmpty) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: state.clothes.length,
                    itemBuilder: (context, index) {
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
                    },
                  );
                }
                if (state.error != null) {
                  return Center(child: Text(state.error!));
                }
                return const UiTextNoData();
              },
            ),
            bottomNavigationBar: _buildBottomNavBar(context),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                _openDetailsPage(context);
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
