import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class UiSnackbar {
  static show(
    BuildContext context,
    String text, {
    duration = 3,
    withVibration = false,
    vibrationDuration = 100,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: Duration(seconds: duration),
      ),
    );
    if (withVibration && await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: vibrationDuration);
    }
  }
}
