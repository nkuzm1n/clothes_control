import 'package:flutter/material.dart';

class AppNavigation {
  static Future push<T extends Object?>(BuildContext context, Widget widget) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
    );
  }

  static Future pushReplacement<T extends Object?>(BuildContext context, Widget widget,
      [T? result]) async {
    return await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => widget,
      ),
      result: result,
    );
  }

  static void pop<T extends Object?>(BuildContext context, [T? result]) {
    Navigator.pop(context, result);
  }
}
