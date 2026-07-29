import 'package:flutter/material.dart';
import 'package:clothes_control/features/cloth/presentation/screens/clothes_list_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Clothes Control',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: const ColorScheme.light(),
        useMaterial3: true,
      ),
      home: ClothesListScreen(),
    );
  }
}
