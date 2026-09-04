import 'package:flutter/material.dart';

class SliverPageLayout extends StatelessWidget {
  final Widget sliverAppBar;
  final Widget sliverBody;
  final Widget? floatingActionButton;
  final double? floatingActionButtonBottom;
  final double? floatingActionButtonRight;
  final Widget? extraBottom;

  const SliverPageLayout({
    super.key,
    required this.sliverAppBar,
    required this.sliverBody,
    this.floatingActionButton,
    this.floatingActionButtonBottom = 20,
    this.floatingActionButtonRight = 20,
    this.extraBottom,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            sliverAppBar,
            sliverBody,
          ],
        ),
        if (extraBottom != null) extraBottom!,
        if (floatingActionButton != null)
          Positioned(
            bottom: floatingActionButtonBottom,
            right: floatingActionButtonRight,
            child: floatingActionButton!,
          )
      ],
    );
  }
}
