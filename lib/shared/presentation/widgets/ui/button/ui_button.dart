import 'package:flutter/material.dart';

class UiButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String? text;
  final IconData? icon;
  final bool disabled;
  final Color? color;
  final double width;
  final double height;

  const UiButton({
    super.key,
    required this.onPressed,
    required this.width,
    required this.height,
    this.text,
    this.icon,
    this.disabled = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: disabled ? null : onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) Icon(icon, color: Colors.white),
              SizedBox(width: icon != null ? 8.0 : 0),
              if (text != null)
                Text(text!, style: const TextStyle(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
