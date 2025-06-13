import 'package:clothes_control/features/clothes_list/presentation/widgets/clothes_list_item.dart';
import 'package:clothes_control/features/settings/presentation/settings_screen.dart';
import 'package:clothes_control/shared/data/dto/cloth/cloth_dto.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/data/repositories/category_repository.dart';
import 'package:clothes_control/shared/data/repositories/clothes_repository.dart';
import 'package:clothes_control/shared/data/repositories/status_repository.dart';
import 'package:clothes_control/shared/presentation/navigation/navigation_bar.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/text/ui_text_no_data.dart';
import 'package:clothes_control/shared/utils/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/clothes_list/presentation/bloc/clothes_list_bloc.dart';
import 'package:clothes_control/features/clothes_detail/presentation/widgets/clothes_detail_screen.dart';

class ClothesListScreen extends StatelessWidget {
  ClothesListScreen({super.key});

  final _searchInputController = TextEditingController();

  _openDetailsPage(BuildContext context, {ClothDTO? cloth}) async {
    await AppNavigation.push(context, ClothesDetailScreen(cloth: cloth));
    if (context.mounted) {
      context.read<ClothesListBloc>().add(const LoadClothesListEvent());
    }
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
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, right: 12, bottom: 16, left: 12),
                  child: TextField(
                    controller: _searchInputController,
                    decoration: InputDecoration(
                      labelText: 'Поиск',
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      suffixIcon: state is ClothesListLoaded && state.searchString != null
                          ? IconButton(
                              onPressed: () {
                                if (_searchInputController.text.isNotEmpty) {
                                  context.read<ClothesListBloc>().add(const LoadClothesListEvent());
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
                      print('SEARCH CHNGED $value');
                      context.read<ClothesListBloc>().add(LoadClothesListEvent(search: value));
                    },
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ClothesListBloc, ClothesListState>(
                    builder: (context, state) {
                      if (state is ClothesListLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is ClothesListLoaded && state.clothesList.isNotEmpty) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          itemCount: state.clothesList.length,
                          itemBuilder: (context, index) {
                            final listItem = state.clothesList[index];
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
                      if (state is ClothesListError) {
                        return Center(child: Text(state.message));
                      }
                      return const UiTextNoData();
                    },
                  ),
                ),
              ],
            ),
            bottomNavigationBar: AppNavigationBar(currentIndex: 0),
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
