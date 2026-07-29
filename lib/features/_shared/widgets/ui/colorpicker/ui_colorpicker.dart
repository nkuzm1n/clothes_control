import 'package:clothes_control/core/utils/navigation/navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

const List<Color> _defaultColors = [
  Colors.red,
  Colors.pink,
  Colors.purple,
  Colors.deepPurple,
  Colors.indigo,
  Colors.blue,
  Colors.lightBlue,
  Colors.cyan,
  Colors.teal,
  Colors.green,
  Colors.lightGreen,
  Colors.lime,
  Colors.yellow,
  Colors.amber,
  Colors.orange,
  Colors.deepOrange,
  Colors.brown,
  Colors.grey,
  Colors.blueGrey,
  Colors.black,
];

const Color _defaultColor = Colors.black;

class UiColorpicker extends StatefulWidget {
  final Color? currentColor;
  final List<Color>? availableColors;
  final Function(Color color)? onColorChanged;

  const UiColorpicker({
    super.key,
    this.currentColor,
    this.availableColors,
    this.onColorChanged,
  });

  static const defaultColors = _defaultColors;

  @override
  State<UiColorpicker> createState() => _UiColorpickerState();
}

class _UiColorpickerState extends State<UiColorpicker> {
  Color? _currentColor;

  _openModalPicker(BuildContext context) {
    return showDialog(
      builder: (context) => AlertDialog(
        title: const Text('Pick a color!'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: _currentColor,
            // useInShowDialog: true,
            availableColors: widget.availableColors ?? _defaultColors,
            onColorChanged: (value) {
              setState(() {
                _currentColor = value;
              });
              if (widget.onColorChanged != null) {
                widget.onColorChanged!(value);
              }
              AppNavigation.pop(context);
            },
          ),
        ),
      ),
      context: context,
    );
  }

  @override
  void initState() {
    super.initState();
    _currentColor = widget.currentColor;
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _currentColor = widget.currentColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: _currentColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        onPressed: () {
          _openModalPicker(context);
        },
        child: Container(),
      ),
    );
  }
}
