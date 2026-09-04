import 'dart:developer';

import 'package:clothes_control/app/router/router.dart';
import 'package:clothes_control/app/di/di_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  ErrorWidget.builder = (details) {
    if (kDebugMode) {
      return ErrorWidget(details.exception);
    } else {
      // TODO: add custom error page
      return ErrorWidget(details.exception);
    }
  };

  FlutterError.onError = (FlutterErrorDetails details) {
    log('🔴 Flutter Error: ${details.exception}');
    FlutterError.presentError(details);
  };

  PlatformDispatcher.instance.onError = (error, stack) {
    log('🟠 Dart Error: $error');
    return true;
  };

  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocator.setup();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Clothes Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light(),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
