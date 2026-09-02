import 'package:clothes_control/app/router/router.dart';
import 'package:clothes_control/app/di/di_config.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initRepositories();
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
