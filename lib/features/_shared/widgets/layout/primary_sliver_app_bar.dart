import 'package:flutter/material.dart';

class PrimarySliverAppBar extends StatelessWidget {
  final Color? backgroundColor;
  final String? titleText;
  final EdgeInsetsGeometry? titlePadding;
  final double? expandedHeight;
  final Widget? leading;
  final List<Widget>? actions;

  const PrimarySliverAppBar({
    super.key,
    this.backgroundColor,
    this.titleText,
    this.titlePadding,
    this.expandedHeight = 150,
    this.leading,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      leading: leading,
      actions: actions,
      flexibleSpace: FlexibleSpaceBar(
        title: (titleText != null)
            ? Text(
                titleText!,
                style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
              )
            : null,
        titlePadding: titlePadding,
      ),
      backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
    );
  }
}
