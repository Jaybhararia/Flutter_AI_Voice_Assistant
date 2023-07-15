import 'package:flutter/material.dart';
import 'package:voice_assistant/Home_Page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rohan',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        scaffoldBackgroundColor : Colors.black,
        appBarTheme: AppBarTheme(
          color: Colors.black,
        )
      ),
      home: const Home_Page(),
    );
  }
}


