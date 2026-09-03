import 'package:clothes_control/core/di/service_locator.dart';
import 'package:clothes_control/domain/repositories/category_repository.dart';
import 'package:clothes_control/features/_shared/bloc/category/category_bloc.dart';
import 'package:clothes_control/features/_shared/widgets/layout/sliver_page_layout.dart';
import 'package:clothes_control/features/_shared/widgets/layout/primary_sliver_app_bar.dart';
import 'package:clothes_control/features/_shared/widgets/ui/snackbar/ui_snackbar.dart';
import 'package:clothes_control/core/router/extensions/app_router_navigation.dart';
import 'package:clothes_control/core/router/route_names.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoriesListScreen extends StatelessWidget {
  const CategoriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CategoryBloc(
        categoryRepository: sl<ICategoryRepository>(),
      )..add(LoadCategoryListEvent()),
      child: const CategoriesListView(),
    );
  }
}

class CategoriesListView extends StatelessWidget {
  const CategoriesListView({super.key});

  void _navigateToCategoryDetailScreen(BuildContext context, {int? id}) async {
    await context.pushNamedAppRoute(
      RouteNames.categoriesDetail,
      pathParameters: {'id': id?.toString() ?? 'new'},
    );
    if (context.mounted) {
      context.read<CategoryBloc>().add(LoadCategoryListEvent());
    }
  }

  void _deleteCategoryItem(BuildContext context, int id) {
    context.read<CategoryBloc>().add(DeleteCategoryFromListEvent(id: id));
  }

  Widget _buildContent(BuildContext context, CategoryState state) {
    if (state is LoadingCategoryListState) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }
    if (state is CategoryErrorState) {
      return SliverFillRemaining(child: Center(child: Text(state.error?.message)));
    }
    if (state is LoadedCategoryListState) {
      if (state.list.isEmpty) {
        return const SliverFillRemaining(child: Center(child: Text('Нет данных')));
      }

      return SliverPadding(
        padding: const EdgeInsets.all(16),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = state.list[index];
              return Card(
                child: ListTile(
                  onTap: () {
                    _navigateToCategoryDetailScreen(context, id: item.id);
                  },
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteCategoryItem(context, item.id);
                    },
                  ),
                  contentPadding: const EdgeInsets.only(left: 12, right: 4, top: 0, bottom: 0),
                ),
              );
            },
            childCount: state.list.length, // Количество элементов
          ),
        ),
      );
    }

    return SliverToBoxAdapter(child: Container());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CategoryBloc, CategoryState>(
      listener: (context, state) {
        if (state.error != null) {
          UiSnackbar.show(context, state.error?.message);
        }
      },
      builder: (context, state) {
        return SliverPageLayout(
          appBar: const PrimarySliverAppBar(
            titleText: 'Категории',
          ),
          body: _buildContent(context, state),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _navigateToCategoryDetailScreen(context);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
