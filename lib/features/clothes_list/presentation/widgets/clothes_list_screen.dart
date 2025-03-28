import 'package:clothes_control/features/clothes_list/presentation/widgets/clothes_list_item.dart';
import 'package:clothes_control/features/settings/presentation/settings_screen.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/data/repositories/clothes_repository.dart';
import 'package:clothes_control/shared/data/repositories/condition_repository.dart';
import 'package:clothes_control/shared/data/repositories/status_repository.dart';
import 'package:clothes_control/shared/presentation/widgets/ui/text/ui_text_no_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/features/clothes_list/presentation/bloc/clothes_list_bloc.dart';
import 'package:clothes_control/features/clothes_detail/presentation/widgets/clothes_detail_screen.dart';

class ClothesListScreen extends StatelessWidget {
  const ClothesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ClothesListBloc(
        clothesRepository: ClothesRepository(databaseHelper: DatabaseHelper()),
        conditionRepository: ConditionRepository(databaseHelper: DatabaseHelper()),
        statusRepository: StatusRepository(databaseHelper: DatabaseHelper()),
      )..add(const LoadClothesList()),
      child: BlocBuilder<ClothesListBloc, ClothesListState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Список вещей',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              actionsPadding: const EdgeInsets.only(right: 18),
              actions: [
                InkWell(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsScreen(),
                      ),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.settings),
                  ),
                ),
              ],
              // backgroundColor: Colors.green.shade200,
            ),
            // backgroundColor: Colors.green.shade200,
            body: BlocBuilder<ClothesListBloc, ClothesListState>(
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
                        condition: listItem.condition,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClothesDetailScreen(itemId: listItem.cloth.id),
                            ),
                          );
                        },
                        onDelete: () {
                          context
                              .read<ClothesListBloc>()
                              .add(DeleteClothesItem(itemId: listItem.cloth.id));
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ClothesDetailScreen(),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          );
        },
      ),
    );
  }
}
