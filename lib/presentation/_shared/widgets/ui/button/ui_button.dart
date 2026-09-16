import 'package:flutter/material.dart';

class UiButton extends StatelessWidget {
  final Function()? onPressed;
  final String? text;
  final Widget? icon;
  final bool disabled;
  final Color? color;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final BoxDecoration? decoration;
  final Widget? child;

  const UiButton({
    super.key,
    this.onPressed,
    this.width,
    this.height,
    this.text,
    this.icon,
    this.disabled = false,
    this.color,
    this.borderRadius,
    this.padding,
    this.decoration,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    BoxDecoration outerDecoration = decoration ??
        BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        );
    return InkWell(
      borderRadius: borderRadius,
      onTap: disabled ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: outerDecoration,
        padding: padding,
        child: Center(
          child: child ??
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) icon!,
                  SizedBox(width: icon != null && text != null ? 8.0 : 0),
                  if (text != null) Text(text!, style: const TextStyle(color: Colors.white)),
                ],
              ),
        ),
      ),
    );
  }
}
