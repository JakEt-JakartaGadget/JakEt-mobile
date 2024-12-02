import 'package:flutter/material.dart';

class ComparisonCard extends StatelessWidget {
  final String brand;

  const ComparisonCard({Key? key, required this.brand}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.purple[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            brand,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          const Text("Camera: xxx MP"),
          const Text("Storage: xxx GB"),
          const Text("Battery: xxx mAh"),
          const Text("Display: xxx pixels"),
        ],
      ),
    );
  }
}
