import 'package:flutter/material.dart';

class CustomSliverLayout extends StatelessWidget {
  final Widget? appBar;
  final Widget body;
  final Widget? extraBottom;
  final Widget? floatingActionButton;
  final double? floatingActionButtonBottom;
  final double? floatingActionButtonRight;

  const CustomSliverLayout({
    super.key,
    this.appBar,
    required this.body,
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
            if (appBar != null) appBar!,
            body,
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
