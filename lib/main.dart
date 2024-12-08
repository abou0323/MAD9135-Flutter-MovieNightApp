import 'package:flutter/material.dart';
import 'package:flutter_movie_night_app/screens/welcome_screen.dart';
import 'package:flutter_movie_night_app/utils/app_state.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (context) => AppState(),
    child: const MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        useMaterial3: true,
        colorScheme: ColorScheme(
          brightness: Brightness.light,
          primary: Colors.indigo,
          onPrimary: Colors.white,
          secondary: Colors.indigo.shade100,
          onSecondary: Colors.black,
          error: Colors.red.shade900,
          onError: Colors.red.shade500,
          surface: Colors.indigo.shade50,
          onSurface: Colors.black,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontSize: 32),
          headlineSmall: TextStyle(fontSize: 24),
          titleLarge: TextStyle(fontSize: 22),
          titleMedium: TextStyle(fontSize: 16),
        ),
        appBarTheme: AppBarTheme(
          color: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          titleTextStyle: TextStyle(
            fontFamily: 'Poppins',
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: Theme.of(context).textTheme.headlineLarge?.fontSize,
          ),
          iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
      ),
      home: const WelcomeScreen(),
    );
  }
}
