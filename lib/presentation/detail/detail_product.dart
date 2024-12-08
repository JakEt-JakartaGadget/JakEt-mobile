import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  const ProductDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Navigasi ke homepage (Pastikan homepage sudah diatur)
            Navigator.pushReplacementNamed(context, '/home');
          },
          child: const Text('Kembali ke Homepage'),
        ),
      ),
    );
  }
}
