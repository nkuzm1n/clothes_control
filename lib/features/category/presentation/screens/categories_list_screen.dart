import 'package:clothes_control/features/category/presentation/screens/categories_detail_screen.dart';
import 'package:clothes_control/features/cloth/presentation/blocs/clothes_list/clothes_list_bloc.dart';
import 'package:clothes_control/core/data/bloc/category/category_bloc.dart';
import 'package:clothes_control/core/data/dto/category/category_dto.dart';
import 'package:clothes_control/core/data/local/database_helper.dart';
import 'package:clothes_control/core/data/repositories/category_repository.dart';
import 'package:clothes_control/shared/navigation/navigation_bar.dart';
import 'package:clothes_control/shared/ui/snackbar/ui_snackbar.dart';
import 'package:clothes_control/core/utils/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesListScreen extends StatelessWidget {
  const CategoriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc(
        categoryRepository: CategoryRepositoryImpl(databaseHelper: DatabaseHelper()),
      )..add(LoadCategoryListEvent()),
      child: const CategoriesListView(),
    );
  }
}

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  void _navigateToCategoryDetailScreen(BuildContext context, {CategoryDTO? category}) async {
    await AppNavigation.push(context, CategoriesDetailScreen(category: category));
    if (context.mounted) {
      context.read<CategoryBloc>().add(LoadCategoryListEvent());
    }
  }

  void _deleteCategoryItem(BuildContext context, CategoryDTO category) {
    context.read<CategoryBloc>().add(DeleteCategoryFromListEvent(category: category));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Категории',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state.error != null) {
            UiSnackbar.show(context, state.error?.message);
          }
        },
        builder: (context, state) {
          if (state is LoadingCategoryListState) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is CategoryErrorState) {
            return Center(child: Text(state.error?.message));
          }
          if (state is LoadedCategoryListState) {
            if (state.list.isEmpty) {
              return const Center(child: Text('Нет данных'));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final item = state.list[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      _navigateToCategoryDetailScreen(context, category: item);
                    },
                    title: Text(item.name),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteCategoryItem(context, item);
                      },
                    ),
                    contentPadding: const EdgeInsets.only(left: 12, right: 4, top: 0, bottom: 0),
                  ),
                );
              },
            );
          }
          return Container();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          _navigateToCategoryDetailScreen(context);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppNavigationBar(currentIndex: 1),
    );
  }
}
