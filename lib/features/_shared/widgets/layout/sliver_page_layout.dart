import 'package:flutter/material.dart';

class SliverPageLayout extends StatelessWidget {
  final Widget _appBar;
  final Widget _body;
  final Widget? _floatingActionButton;

  const SliverPageLayout({
    super.key,
    required Widget appBar,
    required Widget body,
    Widget? floatingActionButton,
  })  : _appBar = appBar,
        _body = body,
        _floatingActionButton = floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            _appBar,
            _body,
          ],
        ),
        if (_floatingActionButton != null)
          Positioned(
            bottom: 20,
            right: 20,
            child: _floatingActionButton,
          )
      ],
    );
  }
}
