// lib/presentation/homepage/comparison.dart

import 'package:flutter/material.dart';
import '../../models/device.dart';
import 'package:jaket_mobile/widgets/custom_image_view.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({Key? key}) : super(key: key);

  @override
  _ComparisonPageState createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  List<Device> devices = [];
  String? selectedModel1;
  String? selectedModel2;
  Device? device1;
  Device? device2;

  @override
  void initState() {
    super.initState();
    fetchDevices();
  }

  Future<void> fetchDevices() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/comparison/devices/'));

    if (response.statusCode == 200) {
      List<dynamic> deviceJson = json.decode(response.body);
      setState(() {
        devices = deviceJson.map((json) => Device.fromJson(json)).toList();
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load devices')),
      );
    }
  }

  Future<void> compareDevices() async {
    if (selectedModel1 == null || selectedModel2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both devices to compare.')),
      );
      return;
    }

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/comparison/compare/'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'model1': selectedModel1,
        'model2': selectedModel2,
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        device1 = Device.fromJson(data['device1']);
        device2 = Device.fromJson(data['device2']);
      });
    } else {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to compare devices')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menghapus AppBar untuk tampilan lebih polos
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header custom
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: Color(0xFF6D0CC9),
                    child: Icon(Icons.arrow_back, color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                Text(
                  "Comparison",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              "Let's Compare them",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            // Dropdown Perangkat 1
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Choose a device',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              value: selectedModel1,
              items: devices.map((Device device) {
                return DropdownMenuItem<String>(
                  value: device.model,
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: device.pictureUrl,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Text(device.productName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedModel1 = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            // VS Text
            Text(
              "VS",
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6D0CC9),
              ),
            ),
            SizedBox(height: 20),
            // Dropdown Perangkat 2
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Choose a device',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
              ),
              value: selectedModel2,
              items: devices.map((Device device) {
                return DropdownMenuItem<String>(
                  value: device.model,
                  child: Row(
                    children: [
                      CustomImageView(
                        imagePath: device.pictureUrl,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10),
                      Text(device.productName),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedModel2 = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            // Tombol Compare dengan Gradient
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF527EEE),
                    Color(0xFF766DEE),
                    Color(0xFF985CEF),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(28.0),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent, // Background transparan
                  shadowColor: Colors.transparent, // Hilangkan bayangan
                  elevation: 0, // Hilangkan elevation
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15.0),
                ),
                onPressed: compareDevices,
                child: Text(
                  'Compare',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
            // Hasil Perbandingan
            if (device1 != null && device2 != null)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: buildDeviceCard(device1!)),
                  Container(
                    height: 500, // Sesuaikan tinggi garis sesuai kebutuhan
                    width: 2,
                    color: Colors.grey[400],
                  ),
                  Expanded(child: buildDeviceCard(device2!)),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget buildDeviceCard(Device device) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.productName,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          CustomImageView(
            imagePath: device.pictureUrl,
            height: 150,
            width: 150,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 10),
          // Spesifikasi
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand: ${device.brand}'),
              Text('Battery: ${device.batteryCapacity} mAh'),
              Text('Price: ${device.priceInIdr}'),
              Text('RAM: ${device.ram}'),
              Text('Camera: ${device.camera}'),
              Text('Processor: ${device.processor}'),
              Text('Display: ${device.screenSize}'),
            ],
          ),
          SizedBox(height: 20),
          // Tombol View Product Page
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF527EEE),
                  Color(0xFF766DEE),
                  Color(0xFF985CEF),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(28.0),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent, // Background transparan
                shadowColor: Colors.transparent, // Hilangkan bayangan
                elevation: 0, // Hilangkan elevation
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28.0),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
              ),
              onPressed: () async {
                final url = Uri.parse(device.url);
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Could not launch ${device.url}')),
                  );
                }
              },
              child: Text(
                'View product page',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
