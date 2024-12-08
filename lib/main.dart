import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
          displayLarge: TextStyle(fontSize: 57),
          displayMedium: TextStyle(fontSize: 45),
          displaySmall: TextStyle(fontSize: 36),
          headlineLarge: TextStyle(fontSize: 32), // used
          headlineMedium: TextStyle(fontSize: 28),
          headlineSmall: TextStyle(fontSize: 24), // used
          titleLarge: TextStyle(fontSize: 22),
          titleMedium: TextStyle(fontSize: 16), // used
          titleSmall: TextStyle(fontSize: 14),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          bodySmall: TextStyle(fontSize: 12),
          labelLarge: TextStyle(fontSize: 14),
          labelMedium: TextStyle(fontSize: 12),
          labelSmall: TextStyle(fontSize: 11),
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
      home: WelcomeScreen(),
    );
  }
}
