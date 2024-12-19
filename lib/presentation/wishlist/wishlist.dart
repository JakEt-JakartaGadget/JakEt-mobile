import 'package:flutter/material.dart';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';
import 'package:jaket_mobile/presentation/detail/product_card.dart';
import 'package:jaket_mobile/widgets/custom_button_nav_bar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({Key? key}) : super(key: key);

  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    final response = await request.get('http://10.0.2.2:8000/wishlist/wish_json');
    var data = response;
    List<ProductEntry> listProducts = [];
    for (var d in data) {
      if (d != null) {
        listProducts.add(ProductEntry.fromJson(d));
      }
    }
    return listProducts;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            fontFamily: 'Inter', // Pastikan font 'Inter' sudah ditambahkan di pubspec.yaml
            fontSize: 20,
            fontWeight: FontWeight.w600, // Semi-bold
          ),
        ),
        centerTitle: true, // Menempatkan judul di tengah
        backgroundColor: Colors.white, // Sesuaikan warna latar belakang AppBar jika diperlukan
        elevation: 0, // Menghilangkan bayangan bawah AppBar
        iconTheme: const IconThemeData(color: Colors.black), // Menyesuaikan warna ikon jika diperlukan
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ProductEntry>>(
          future: fetchProducts(request),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text(
                  'Belum ada yang kamu sukai :(.',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xff59A5D8),
                    fontFamily: 'Inter', 
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            } else {
              final limitedProducts = snapshot.data!.take(6).toList();

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: limitedProducts.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                ),
                itemBuilder: (context, index) {
                  final product = limitedProducts[index];
                  return ProductCard(product: product);
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(),
    );
  }
}
