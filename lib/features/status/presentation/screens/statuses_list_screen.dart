import 'package:clothes_control/core/di/service_locator.dart';
import 'package:clothes_control/domain/repositories/status_repository.dart';
import 'package:clothes_control/features/_shared/widgets/ui/snackbar/ui_snackbar.dart';
import 'package:clothes_control/core/router/extensions/app_router_navigation.dart';
import 'package:clothes_control/core/router/route_names.dart';
import 'package:clothes_control/core/utils/extensions/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/_shared/bloc/status/status_bloc.dart';
import 'package:clothes_control/features/_shared/widgets/layout/sliver_page_layout.dart';
import 'package:clothes_control/features/_shared/widgets/layout/primary_sliver_app_bar.dart';

class StatusesListScreen extends StatelessWidget {
  const StatusesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusBloc(
        statusRepository: sl<IStatusRepository>(),
      )..add(LoadStatusListEvent()),
      child: const StatusesListView(),
    );
  }
}

class StatusesListView extends StatelessWidget {
  const StatusesListView({super.key});

  void _navigateToStatusDetailScreen(BuildContext context, {int? id}) async {
    await context.pushNamedAppRoute(
      RouteNames.statusesDetail,
      pathParameters: {'id': id?.toString() ?? 'new'},
    );
    if (context.mounted) {
      context.read<StatusBloc>().add(LoadStatusListEvent());
    }
  }

  void _deleteStatusItem(BuildContext context, int id) {
    context.read<StatusBloc>().add(DeleteStatusFromListEvent(id: id));
  }

  Widget _buildContent(BuildContext context, StatusState state) {
    if (state is LoadingStatusListState) {
      return const SliverFillRemaining(child: Center(child: CircularProgressIndicator()));
    }
    if (state is StatusErrorState) {
      return SliverFillRemaining(child: Center(child: Text(state.error?.message)));
    }
    if (state is LoadedStatusListState) {
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
                    _navigateToStatusDetailScreen(context, id: item.id);
                  },
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ColoredBox(
                      color: HexColor.fromHex(item.color),
                      child: const SizedBox(width: 20, height: 20),
                    ),
                  ),
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _deleteStatusItem(context, item.id);
                    },
                  ),
                  contentPadding: const EdgeInsets.only(left: 12, right: 4, top: 0, bottom: 0),
                ),
              );
            },
            childCount: state.list.length,
          ),
        ),
      );
    }

    return SliverToBoxAdapter(child: Container());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatusBloc, StatusState>(
      listener: (context, state) {
        if (state.error != null) {
          UiSnackbar.show(context, state.error?.message);
        }
      },
      builder: (context, state) {
        return SliverPageLayout(
          appBar: const PrimarySliverAppBar(
            titleText: 'Статусы',
          ),
          body: _buildContent(context, state),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              _navigateToStatusDetailScreen(context);
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
