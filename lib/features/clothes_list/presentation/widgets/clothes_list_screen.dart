import 'package:clothes_control/features/clothes_list/presentation/widgets/clothes_list_item.dart';
import 'package:clothes_control/features/settings/presentation/settings_screen.dart';
import 'package:clothes_control/shared/data/local/database_helper.dart';
import 'package:clothes_control/shared/data/repositories/clothes_repository.dart';
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
      )..add(const LoadClothesList()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Список вещей',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          actionsPadding: const EdgeInsets.only(right: 18),
          actions: [
            InkWell(
              onTap: () {
                Navigator.push(
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
            if (state is ClothesListLoaded) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: state.clothesList.length,
                itemBuilder: (context, index) {
                  final clothesItem = state.clothesList[index];
                  return ClothesListItem(
                    clothesItem: clothesItem,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClothesDetailScreen(itemId: clothesItem.id),
                        ),
                      );
                    },
                    onDelete: () {
                      context
                          .read<ClothesListBloc>()
                          .add(DeleteClothesItem(itemId: clothesItem.id));
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
            // TODO: Implement add new clothes item
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
