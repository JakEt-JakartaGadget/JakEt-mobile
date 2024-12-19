import 'package:flutter/material.dart';

class AllProduct extends StatelessWidget {
  const AllProduct({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Product'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children:  [
          SizedBox(
            child: GestureDetector(
              child: const Text(
                'All Product',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onTap : () {
                print('All Product');
              },
            ),
          ),
          ],
        )
      )
    );
  }
}
