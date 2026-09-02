import 'package:clothes_control/features/_shared/widgets/ui/snackbar/ui_snackbar.dart';
import 'package:clothes_control/shared/router/extensions/app_router_navigation.dart';
import 'package:clothes_control/shared/router/route_names.dart';
import 'package:clothes_control/shared/utils/extensions/hex_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/_shared/bloc/status/status_bloc.dart';
import 'package:clothes_control/data/database/database_helper.dart';
import 'package:clothes_control/data/repositories/status_repository_impl.dart';

class StatusesListScreen extends StatelessWidget {
  const StatusesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusBloc(
        statusRepository: StatusRepositoryImpl(databaseHelper: SqliteDatabase()),
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

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StatusBloc, StatusState>(
      listener: (context, state) {
        if (state is StatusErrorState) {
          UiSnackbar.show(context, state.error?.message);
        }
      },
      builder: (context, state) {
        if (state is LoadingStatusListState) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is StatusErrorState) {
          return Center(child: Text(state.error?.message));
        }
        if (state is LoadedStatusListState) {
          if (state.list.isEmpty) {
            return const Center(child: Text('Нет данных'));
          }
          return Stack(children: [
            AppBar(
              title: const Text(
                'Статусы',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
            ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final statusItem = state.list[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      _navigateToStatusDetailScreen(context, id: statusItem.id);
                    },
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: ColoredBox(
                        color: HexColor.fromHex(statusItem.color),
                        child: const SizedBox(width: 20, height: 20),
                      ),
                    ),
                    title: Text(statusItem.name),
                    trailing: IconButton(
                      onPressed: () {
                        _deleteStatusItem(context, statusItem.id);
                      },
                      icon: const Icon(Icons.delete),
                    ),
                    contentPadding: const EdgeInsets.only(left: 12, right: 4, top: 0, bottom: 0),
                  ),
                );
              },
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: () async {
                  _navigateToStatusDetailScreen(context);
                },
                child: const Icon(Icons.add),
              ),
            ),
          ]);
        }
        return Container();
      },
    );
  }
}
