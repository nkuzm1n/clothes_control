import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:clothes_control/core/app/bloc/global_bloc_observer.dart';
import 'package:clothes_control/core/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = GlobalBlocObserver();
  runApp(const App());
}
