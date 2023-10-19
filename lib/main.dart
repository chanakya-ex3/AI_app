import 'package:ai_app/Pages/Authpage.dart';
import 'package:ai_app/MyRoutes.dart';
import 'package:ai_app/Pages/Chat.dart';
import 'package:ai_app/Pages/Homepage.dart';
import 'package:ai_app/Pages/Settings.dart';
import 'package:ai_app/Pages/SplashScreen.dart';
import 'package:ai_app/Pages/Theme.dart';
import 'package:ai_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GestureBinding.instance.resamplingEnabled = true;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(AiAPP());
}

class AiAPP extends StatefulWidget {
  const AiAPP({super.key});
  @override
  State<AiAPP> createState() => _AiAPPState();
}

class _AiAPPState extends State<AiAPP> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, child) {
        final themeProvider = Provider.of<ThemeProvider>(context);
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'BijuGPT',
            themeMode: themeProvider.themeMode,
            theme: MyThemes.theme,
            darkTheme: MyThemes.darktheme,
            routes: {
              MyRoutes.auth: (context) => AuthPage(),
              MyRoutes.home: (context) => Homepage(),
              MyRoutes.chat: (context) => ChatPage(),
              MyRoutes.splashScreen: (context) => SplashScreen(),
              MyRoutes.settings: (context) => SettingsPage(),
            },
            home: StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return SplashScreen();
                }
                if (snapshot.hasError) {
                  ScaffoldMessenger.of(context).clearSnackBars();
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("An error has occured")));
                }
                return AuthPage();
              },
            ));
      },
    );
  }
}
