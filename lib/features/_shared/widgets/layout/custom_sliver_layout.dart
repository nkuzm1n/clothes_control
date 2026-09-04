import 'package:flutter/material.dart';

class CustomSliverLayout extends StatelessWidget {
  final Widget? sliverAppBar;
  final Widget sliverBody;
  final Widget? extraBottom;
  final Widget? floatingActionButton;
  final double? floatingActionButtonBottom;
  final double? floatingActionButtonRight;

  const CustomSliverLayout({
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
            if (sliverAppBar != null) sliverAppBar!,
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
