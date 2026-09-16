import 'package:flutter/material.dart';
import 'package:clothes_control/presentation/_shared/widgets/layout/custom_sliver_layout.dart';
import 'package:clothes_control/presentation/_shared/widgets/layout/custom_sliver_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const CustomSliverLayout(
      appBar: CustomSliverAppBar(titleText: 'Настройки'),
      body: SliverFillRemaining(
        child: Center(
          child: Text('Раздел в разработке...', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
