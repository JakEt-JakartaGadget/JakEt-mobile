import 'package:flutter/material.dart';
import 'screens/comparison_screen.dart';

void main() {
  runApp(const ComparisonApp());
}

class ComparisonApp extends StatelessWidget {
  const ComparisonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Comparison App',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const ComparisonScreen(),
    );
  }
}
