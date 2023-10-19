import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// theme: ThemeData(
//     textTheme: GoogleFonts.latoTextTheme(
//       Theme.of(context).textTheme,
//     ),
//   ),

class ThemeProvider extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.system;

  void toggleTheme() {
    themeMode = themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}

class MyThemes {
  static ThemeData theme = ThemeData(
    textTheme: GoogleFonts.hammersmithOneTextTheme(),
  ).copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.black,
          primary: Colors.black,
          secondary: const Color.fromARGB(255, 180, 0, 75),
          tertiary: Colors.white70,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onTertiary: Colors.white,
          surface: Colors.white,
          onSurface: Colors.black,
          background: Colors.white,
          onBackground: Colors.black,
          error: Colors.red,
          onError: Colors.white,
          brightness: Brightness.light));

  static ThemeData darktheme = ThemeData(
    textTheme: GoogleFonts.hammersmithOneTextTheme(),
  ).copyWith(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.white,
          primary: Colors.white,
          secondary: const Color.fromARGB(255, 180, 0, 75),
          tertiary: Colors.white70,
          onPrimary: Colors.white,
          onSecondary: Colors.black,
          onTertiary: Colors.black,
          surface: Colors.black,
          onSurface: Colors.white,
          background: Colors.black,
          onBackground: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          brightness: Brightness.dark));
}
