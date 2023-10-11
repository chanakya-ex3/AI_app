import 'package:ai_app/Pages/Authpage.dart';
import 'package:ai_app/MyRoutes.dart';
import 'package:ai_app/Pages/Homepage.dart';
import 'package:ai_app/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'BijuGPT',
        theme: ThemeData().copyWith(
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
                brightness: Brightness.light)),
        routes: {
          MyRoutes.auth: (context) => AuthPage(),
          MyRoutes.home: (context) => Homepage()
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Homepage();
            }
            if (snapshot.hasError) {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("An error has occured")));
            }
            return AuthPage();
          },
        ));
  }
}
