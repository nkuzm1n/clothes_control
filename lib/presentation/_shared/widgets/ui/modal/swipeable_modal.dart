import 'package:flutter/material.dart';

class SwipeableModal extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final double elevation;
  final ShapeBorder? shape;
  final Clip clipBehavior;
  final Color barrierColor;
  final bool isScrollControlled;
  final bool enableDrag;
  final bool isDismissible;
  final BoxConstraints? constraints;

  const SwipeableModal({
    super.key,
    required this.child,
    this.backgroundColor = Colors.white,
    this.elevation = 0,
    this.shape,
    this.clipBehavior = Clip.antiAlias,
    this.barrierColor = Colors.black54,
    this.isScrollControlled = true,
    this.enableDrag = true,
    this.isDismissible = true,
    this.constraints,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    Color backgroundColor = Colors.white,
    double elevation = 0,
    ShapeBorder? shape,
    Clip clipBehavior = Clip.antiAlias,
    Color barrierColor = Colors.black54,
    bool isScrollControlled = true,
    bool enableDrag = true,
    bool isDismissible = true,
    BoxConstraints? constraints,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      builder: builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      isScrollControlled: isScrollControlled,
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      constraints: constraints,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle indicator
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ),
          child,
        ],
      ),
    );
  }
}
