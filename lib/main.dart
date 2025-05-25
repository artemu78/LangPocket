import 'package:flutter/material.dart';
import 'package:LangPocket/screens/main_screen.dart'; // Import the MainScreen
import 'package:LangPocket/widgets/main_app_scaffold.dart'; // Added import for MainAppScaffold
import 'database_helper.dart';
import 'vocabulary_service.dart'; // Import the new service


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LangPocket',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
      ),
      home: const MainScreen(), // Changed to MainScreen
    );
  }
}

// MyHomePage and _MyHomePageState have been moved to lib/screens/vocabulary_add_screen.dart
