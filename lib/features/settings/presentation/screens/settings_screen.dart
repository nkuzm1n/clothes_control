import 'package:flutter/material.dart';
import 'package:clothes_control/features/_shared/widgets/layout/sliver_page_layout.dart';
import 'package:clothes_control/features/_shared/widgets/layout/primary_sliver_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverPageLayout(
      appBar: PrimarySliverAppBar(titleText: 'Настройки'),
      body: SliverToBoxAdapter(
        child: Center(
          child: Text('Раздел в разработке...', style: TextStyle(fontSize: 24)),
        ),
      ),
    );
  }
}
