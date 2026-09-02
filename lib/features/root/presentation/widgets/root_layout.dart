import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RootLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RootLayout({
    super.key,
    required this.navigationShell,
  });

  Widget _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: navigationShell.currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) => _onTap(context, index),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.checkroom_rounded), label: 'Гардероб'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Категории'),
        BottomNavigationBarItem(icon: Icon(Icons.circle), label: 'Статусы'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
