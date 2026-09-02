import 'package:clothes_control/app/router/router.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
