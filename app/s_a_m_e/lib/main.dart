import 'package:flutter/material.dart';
import 'package:s_a_m_e/colors.dart';
import 'admin.dart';

void main() {
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
      home: Admin(),
    );
  }
}
