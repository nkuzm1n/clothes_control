import 'package:clothes_control/features/status/presentation/screens/statuses_detail_screen.dart';
import 'package:clothes_control/core/data/dto/status/status_dto.dart';
import 'package:clothes_control/shared/ui/snackbar/ui_snackbar.dart';
import 'package:clothes_control/core/utils/extensions/hex_color.dart';
import 'package:clothes_control/core/utils/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/core/data/bloc/status/status_bloc.dart';
import 'package:clothes_control/core/data/local/database_helper.dart';
import 'package:clothes_control/core/data/repositories/status_repository.dart';
import 'package:clothes_control/shared/navigation/navigation_bar.dart';

class StatusesListScreen extends StatelessWidget {
  const StatusesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StatusBloc(
        statusRepository: StatusRepositoryImpl(databaseHelper: DatabaseHelper()),
      )..add(LoadStatusListEvent()),
      child: const StatusesListView(),
    );
  }
}

class StatusesListView extends StatelessWidget {
  const StatusesListView({super.key});

  void _navigateToStatusDetailScreen(BuildContext context, {StatusDTO? status}) async {
    await AppNavigation.push(context, StatusesDetailScreen(status: status));
    if (context.mounted) {
      context.read<StatusBloc>().add(LoadStatusListEvent());
    }
  }

  void _deleteStatusItem(BuildContext context, StatusDTO status) {
    context.read<StatusBloc>().add(DeleteStatusFromListEvent(status: status));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Статусы',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocConsumer<StatusBloc, StatusState>(
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
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                final statusItem = state.list[index];
                return Card(
                  child: ListTile(
                    onTap: () {
                      _navigateToStatusDetailScreen(context, status: statusItem);
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
                        _deleteStatusItem(context, statusItem);
                      },
                      icon: const Icon(Icons.delete),
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
          _navigateToStatusDetailScreen(context);
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: AppNavigationBar(currentIndex: 2),
    );
  }
}
