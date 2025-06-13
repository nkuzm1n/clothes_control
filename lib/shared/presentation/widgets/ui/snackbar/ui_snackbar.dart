import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class UiSnackbar {
  static show(
    BuildContext context,
    String text, {
    double? elevation,
    int duration = 3,
    bool withVibration = false,
    int vibrationDuration = 100,
  }) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        elevation: elevation,
        content: Text(text),
        duration: Duration(seconds: duration),
      ),
    );
    if (withVibration && await Vibration.hasVibrator()) {
      Vibration.vibrate(duration: vibrationDuration);
    }
  }
}
