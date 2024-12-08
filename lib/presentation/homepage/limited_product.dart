import 'package:flutter/material.dart';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';
import 'package:jaket_mobile/presentation/detail/product_card.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class LimitedProductPage extends StatelessWidget {
  const LimitedProductPage({Key? key}) : super(key: key);

  Future<List<ProductEntry>> fetchProducts(CookieRequest request) async {
    final response = await request.get('http://10.0.2.2:8000/json_allproduct/');
    var data = response;
    List<ProductEntry> listProducts = [];
    for (var d in data) {
      if (d != null) {
        listProducts.add(ProductEntry.fromJson(d));
      }
    }
    return listProducts;
  }

  double calculateAverageRating(Fields fields) {
    int totalVotes = fields.oneStar + fields.twoStar + fields.threeStar + fields.fourStar + fields.fiveStar;
    if (totalVotes == 0) return 0.0;
    var weightedSum = (1 * fields.oneStar) + 
                         (2 * fields.twoStar) + 
                         (3 * fields.threeStar) + 
                         (4 * fields.fourStar) + 
                         (5 * fields.fiveStar);
    return weightedSum / totalVotes;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: FutureBuilder(
        future: fetchProducts(request),
        builder: (context, AsyncSnapshot<List<ProductEntry>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data produk pada Ayo Belanja.',
                style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
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
    );
  }
}
