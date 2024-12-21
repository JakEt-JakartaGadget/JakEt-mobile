import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// Pastikan mengimpor model Comparison dari device.dart
// Ganti path ini sesuai struktur folder Anda.
import '../../models/device.dart';  
import '../homepage/homepage.dart'; // Sesuaikan path ini ke lokasi HomePage Anda

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({Key? key}) : super(key: key);

  @override
  _ComparisonPageState createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  List<Comparison> devices = [];
  String? selectedModel1;
  String? selectedModel2;
  Comparison? device1;
  Comparison? device2;
  bool isLoading = false;
  bool isDevicesLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDevices().then((fetchedDevices) {
      setState(() {
        devices = fetchedDevices.take(100).toList();
        isDevicesLoading = false;
      });
    });
  }

  Future<List<Comparison>> fetchDevices() async {
    final response = await http.get(Uri.parse('http://10.0.2.2:8000/comparison/devices/'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData.map((d) => Comparison.fromJson(d)).toList();
    } else {
      throw Exception('Failed to load devices');
    }
  }

  Future<void> compareDevices() async {
    if (selectedModel1 == null || selectedModel2 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Silakan pilih kedua perangkat untuk dibandingkan.')),
      );
      return;
    }

    final deviceSelected1 = devices.firstWhere((d) => d.productName == selectedModel1);
    final deviceSelected2 = devices.firstWhere((d) => d.productName == selectedModel2);

    setState(() {
      isLoading = true;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/comparison/compare/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'model1': deviceSelected1.model,
        'model2': deviceSelected2.model,
      }),
    );

    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        device1 = Comparison.fromJson(data['device1']);
        device2 = Comparison.fromJson(data['device2']);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal membandingkan perangkat')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 600;

    double padding = screenWidth * 0.04;
    double fontSizeHeader = isSmallScreen ? 20 : 28;
    double fontSizeTitle = isSmallScreen ? 24 : 32;
    double fontSizeButton = isSmallScreen ? 14 : 16;
    double fontSizeCard = isSmallScreen ? 12 : 16;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Get.off(() => const HomePage()),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
              size: isSmallScreen ? 20 : 30,
            ),
          ),
        ),
        title: Text(
          "Comparison",
          style: TextStyle(
            fontSize: fontSizeHeader,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: padding),
            Text(
              "Let's Compare them",
              style: TextStyle(
                fontSize: fontSizeTitle,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: padding),

            if (isDevicesLoading)
              const Center(child: CircularProgressIndicator())
            else ...[
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Choose a device',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16.0),
                      ),
                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                      value: selectedModel1,
                      items: devices.map((Comparison device) {
                        return DropdownMenuItem<String>(
                          value: device.productName,
                          child: Text(
                            device.productName,
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedModel1 = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding),
              Text(
                "VS",
                style: TextStyle(
                  fontSize: isSmallScreen ? 36 : 48,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6D0CC9),
                ),
              ),
              SizedBox(height: padding),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Choose a device',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 8 : 16.0),
                      ),
                      icon: const Icon(Icons.arrow_drop_down, size: 20),
                      value: selectedModel2,
                      items: devices.map((Comparison device) {
                        return DropdownMenuItem<String>(
                          value: device.productName,
                          child: Text(
                            device.productName,
                            style: TextStyle(fontSize: isSmallScreen ? 12 : 16),
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedModel2 = newValue;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: padding),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.0),
                  ),
                ),
                onPressed: compareDevices,
                child: Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: Text(
                      'Compare',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: fontSizeButton,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: padding * 2),
              if (isLoading) const CircularProgressIndicator(),
              if (device1 != null && device2 != null)
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 800) {
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: buildDeviceCard(device1!, fontSizeCard, isSmallScreen)),
                          Expanded(child: buildDeviceCard(device2!, fontSizeCard, isSmallScreen)),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          buildDeviceCard(device1!, fontSizeCard, isSmallScreen),
                          SizedBox(height: padding),
                          buildDeviceCard(device2!, fontSizeCard, isSmallScreen),
                        ],
                      );
                    }
                  },
                ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildDeviceCard(Comparison device, double fontSize, bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: isSmallScreen ? 8.0 : 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            device.productName,
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            device.brand,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 18,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 10),
          Image.network(
            device.pictureUrl,
            height: isSmallScreen ? 100 : 150,
            width: double.infinity,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.broken_image, size: 50);
            },
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DetailRow(label: 'Brand', value: device.brand, fontSize: fontSize),
              DetailRow(label: 'Battery', value: '${device.batteryCapacityMAh} mAh', fontSize: fontSize),
              DetailRow(label: 'Price', value: device.priceIdr, fontSize: fontSize),
              DetailRow(label: 'RAM', value: device.ram, fontSize: fontSize),
              DetailRow(label: 'Camera', value: device.camera, fontSize: fontSize),
              DetailRow(label: 'Processor', value: device.processor, fontSize: fontSize),
              DetailRow(label: 'Display', value: device.screenSize, fontSize: fontSize),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6D0CC9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onPressed: () async {
                String url = device.url;
                if (!url.startsWith('http://') && !url.startsWith('https://')) {
                  url = 'https://' + url;
                }

                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  // Menggunakan LaunchMode.externalApplication agar terbuka di browser atau app eksternal
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } else {
                  print('Cannot launch URL: $url');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Could not launch URL')),
                  );
                }
              },
              child: const Text(
                'View Product Page',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final double fontSize;

  const DetailRow({
    Key? key,
    required this.label,
    required this.value,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: fontSize,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: fontSize),
              softWrap: true,
              maxLines: null,
            ),
          ),
        ],
      ),
    );
  }
}
