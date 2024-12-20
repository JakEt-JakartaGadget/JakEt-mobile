// lib/presentation/detail/product_card.dart

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';
import 'package:jaket_mobile/presentation/detail/detail_product.dart';
import 'package:jaket_mobile/auth_controller.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final ProductEntry product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final formatter = NumberFormat.decimalPattern('id_ID');

    int totalVotes = product.fields.oneStar +
        product.fields.twoStar +
        product.fields.threeStar +
        product.fields.fourStar +
        product.fields.fiveStar;
    double averageRating = totalVotes > 0
        ? (1 * product.fields.oneStar +
                2 * product.fields.twoStar +
                3 * product.fields.threeStar +
                4 * product.fields.fourStar +
                5 * product.fields.fiveStar) /
            totalVotes
        : 0;

    bool isFavorite = authController.isProductFavorite(product.pk);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailPage(product: product), // Pass the product
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: SizedBox(
                width: 100.0,
                height: 150.0,
                child: Image.network(
                  product.fields.imageUrl.isNotEmpty ? product.fields.imageUrl : '',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${product.fields.brand} ${product.fields.model}',
                    style: GoogleFonts.inter(
                      fontSize: 13.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (authController.isLoggedIn) {
                      bool success;
                      if (isFavorite) {
                        success = await authController.removeFromFavorites(product.pk);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Removed from favorites")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to remove from favorites")),
                          );
                        }
                      } else {
                        success = await authController.addToFavorites(product.pk);
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Added to favorites")),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Failed to add to favorites")),
                          );
                        }
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please log in to manage favorites")),
                      );
                    }
                  },
                  iconSize: 20.0,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : const Color(0xFF6D0CC9),
                    size: 20.0,
                  ),
                ),
              ],
            ),
            Text(
              'Storage: ${product.fields.storage}, Memory: ${product.fields.ram}',
              style: GoogleFonts.inter(
                fontSize: 10.0,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 5.0),
            Row(
              children: List.generate(5, (index) {
                return _buildStar(index, averageRating);
              }),
            ),
            const SizedBox(height: 5.0),
            Text(
              'Rp.${formatter.format(product.fields.priceInr ?? 0)}',
              style: GoogleFonts.inter(
                fontSize: 12.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStar(int index, double rating) {
    int fullStars = rating.floor();
    double fractional = rating - fullStars;
    Color starColor = Colors.yellow;

    if (index < fullStars) {
      return Icon(Icons.star, color: starColor, size: 12.0);
    } else if (index == fullStars && fractional >= 0.5) {
      return Stack(
        children: [
          Icon(Icons.star_border, color: starColor, size: 12.0),
          ClipRect(
            clipper: HalfClipper(),
            child: Icon(Icons.star, color: starColor, size: 12.0),
          ),
        ],
      );
    } else {
      return Icon(Icons.star_border, color: starColor, size: 12.0);
    }
  }
}

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}
