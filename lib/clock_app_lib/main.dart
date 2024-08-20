import 'package:flutter/material.dart';
import 'package:world_time/clock_app_lib/main_screen.dart';

void main() {
  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: TextTheme(
              bodyLarge: TextStyle(fontSize: 40.0, color: Colors.black))),
      home: MainScreen(),
    );
  }
}
