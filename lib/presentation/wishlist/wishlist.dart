import 'package:flutter/material.dart';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';
import 'package:jaket_mobile/presentation/detail/product_card.dart';
import 'package:jaket_mobile/widgets/custom_button_nav_bar.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({Key? key}) : super(key: key);

  @override
  _WishlistPageState createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  late Future<List<ProductEntry>> _futureProducts;
  List<ProductEntry> _products = [];

  @override
  void initState() {
    super.initState();
    final request = context.read<CookieRequest>();
    _futureProducts = fetchProducts(request);
  }

  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    final response = await request.get('http://10.0.2.2:8000/wishlist/wish_json');
    var data = response;
    List<ProductEntry> listProducts = [];
    for (var d in data) {
      if (d != null) {
        listProducts.add(ProductEntry.fromJson(d));
      }
    }
    _products = listProducts;
    return listProducts;
  }

  void _removeProduct(String productId) {
    setState(() {
      _products.removeWhere((product) => product.pk == productId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Wishlist',
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<List<ProductEntry>>(
          future: _futureProducts,
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
              final limitedProducts = _products.take(6).toList();

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
                  return ProductCard(
                    product: product,
                    onUnfavorite: () {
                      _removeProduct(product.pk);
                    },
                  );
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
