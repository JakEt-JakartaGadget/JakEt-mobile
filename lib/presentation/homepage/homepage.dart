// lib/presentation/homepage/homepage.dart

import 'package:flutter/material.dart';
import '../../routes/app_routes.dart';
import 'package:jaket_mobile/widgets/custom_elevated_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        // Properti AppBar lainnya
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Welcome to the Home Page'),
            SizedBox(height: 20),
            CustomElevatedButton(
              text: 'Go to Comparison',
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.comparison);
              },
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple, // Sesuaikan dengan skema warna Anda
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0),
              ),
              buttonTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              width: 200,
            ),
          ],
        ),
      ),
    );
  }
}
