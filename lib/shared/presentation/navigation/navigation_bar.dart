import 'package:clothes_control/features/categories_list/presentation/categories_list_screen.dart';
import 'package:clothes_control/features/clothes_list/presentation/widgets/clothes_list_screen.dart';
import 'package:clothes_control/features/statuses_list/presentation/statuses_list_screen.dart';
import 'package:clothes_control/shared/utils/navigation/navigation.dart';
import 'package:flutter/material.dart';

class AppNavigationBar extends StatelessWidget {
  final int currentIndex;

  final pages = [
    ClothesListScreen(),
    const CategoriesListScreen(),
    const StatusesListScreen(),
  ];

  AppNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index < 0 || index > pages.length - 1) {
          return;
        }
        if (index == currentIndex) {
          return;
        }
        AppNavigation.pushReplacement(context, pages[index]);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.checkroom_rounded), label: 'Гардероб'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Категории'),
        BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'Статусы'),
      ],
    );
  }
}
