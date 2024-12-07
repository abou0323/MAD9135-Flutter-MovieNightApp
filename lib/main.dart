import 'package:flutter/material.dart';
import 'package:flutter_movie_night_app/screens/welcome_screen.dart';
import 'package:flutter_movie_night_app/utils/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: WelcomeScreen(),
    );
  }
}
