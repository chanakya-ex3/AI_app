import 'package:ai_app/Pages/Theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSwitchButton extends StatefulWidget {
  const ThemeSwitchButton({super.key});

  @override
  State<ThemeSwitchButton> createState() => _ThemeSwitchButtonState();
}

class _ThemeSwitchButtonState extends State<ThemeSwitchButton> {
  static bool isDark = ThemeProvider().themeMode == ThemeMode.dark;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return IconButton(
      icon: Icon(isDark ? Icons.brightness_4 : Icons.brightness_2_outlined),
      onPressed: () {
        final provider = Provider.of<ThemeProvider>(context, listen: false);
        provider.toggleTheme();
        setState(() {
          isDark = !isDark;
        });
      },
    );
  }
}
