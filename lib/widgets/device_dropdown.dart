import 'package:flutter/material.dart';

class DeviceDropdown extends StatelessWidget {
  final String label;

  const DeviceDropdown({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      items: [
        DropdownMenuItem(
          value: "Device 1",
          child: Text("Device 1"),
        ),
        DropdownMenuItem(
          value: "Device 2",
          child: Text("Device 2"),
        ),
      ],
      onChanged: (value) {
        // Tambahkan fungsi
      },
    );
  }
}
