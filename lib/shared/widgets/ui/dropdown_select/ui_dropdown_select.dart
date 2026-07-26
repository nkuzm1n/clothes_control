import 'package:flutter/material.dart';

class UiDropdownSelect<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final String? label;
  final String? Function(T?)? validator;
  final void Function(T?)? onChanged;
  final InputDecoration? decoration;

  const UiDropdownSelect({
    super.key,
    this.value,
    required this.items,
    this.label,
    this.validator,
    this.onChanged,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      decoration: decoration ??
          InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
      value: value,
      items: items,
      validator: validator,
      onChanged: onChanged,
    );
  }
}
