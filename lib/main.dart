// lib/main.dart

import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'package:jaket_mobile/presentation/homepage/comparison.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Widget ini adalah root dari aplikasi Anda.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Comparison App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ComparisonPage(),
      // Tambahkan routes jika diperlukan
    );
  }
}
