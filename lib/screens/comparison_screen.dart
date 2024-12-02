import 'package:flutter/material.dart';
import '../widgets/device_dropdown.dart';
import '../widgets/comparison_card.dart';

class ComparisonScreen extends StatelessWidget {
  const ComparisonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Comparison"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Let's Compare them",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.purple,
              ),
            ),
            const SizedBox(height: 20),
            const DeviceDropdown(label: "Select Device 1"),
            const SizedBox(height: 10),
            const DeviceDropdown(label: "Select Device 2"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Tambahkan fungsi tombol
              },
              child: const Text("Compare"),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  ComparisonCard(brand: "Merk 1"),
                  Center(
                    child: Text(
                      "VS",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                  ComparisonCard(brand: "Merk 2"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
