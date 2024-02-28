import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'package:s_a_m_e/account/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Software Aid for Medical Emergencies',
      theme: ThemeData(
          primarySwatch: teal,
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: navy
          ),
          fontFamily: "PT Serif",
          scaffoldBackgroundColor: background,
          appBarTheme: const AppBarTheme(
              backgroundColor: teal,
              centerTitle: true,
              titleTextStyle: TextStyle(
                  fontFamily: "PT Serif",
                  fontSize: 48.0,
                  color: white,
                  fontWeight: FontWeight.bold))),
      home: const Login(),
    );
  }
}
