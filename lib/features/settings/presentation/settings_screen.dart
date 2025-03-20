import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Настройки',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: const Center(
        child: Text(
          'Раздел в разработке...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
