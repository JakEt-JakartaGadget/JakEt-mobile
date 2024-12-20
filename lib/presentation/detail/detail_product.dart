import 'package:flutter/material.dart';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:jaket_mobile/auth_controller.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductEntry product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.decimalPattern('id_ID');
    final authController = Provider.of<AuthController>(context);
    final isFavorite = authController.isProductFavorite(product.pk);

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Stack untuk gambar dan tombol back
            Stack(
              children: [
                // Gambar Produk
                Image.network(
                  product.fields.imageUrl,
                  width: double.infinity,
                  height: 300, // Atur tinggi gambar sesuai kebutuhan
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 300,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(Icons.error, color: Colors.red, size: 50),
                    ),
                  ),
                ),
                // Tombol Back
                Positioned(
                  top: 40, 
                  left: 16,
                  child: CircleAvatar(
                    backgroundColor: Colors.black54,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),

            // Baris Harga dan Tombol Like
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Harga
                  Text(
                    'Rp.${formatter.format(product.fields.priceInr ?? 0)}',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // Tombol Like
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
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.red : const Color(0xFF6D0CC9),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),

            // Brand + Model
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '${product.fields.brand} ${product.fields.model}',
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // Deskripsi Produk
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer nec odio. Praesent libero. Sed cursus ante dapibus diam.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 16.0),

            // Spesifikasi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Specification',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8.0),

            // Spesifikasi Camera
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SpecificationRow(
                title: 'Camera',
                value: product.fields.cameraMp,
              ),
            ),
            const SizedBox(height: 8.0),

            // Spesifikasi Storage
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SpecificationRow(
                title: 'Storage',
                value: product.fields.storage,
              ),
            ),
            const SizedBox(height: 8.0),

            // Spesifikasi Battery
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SpecificationRow(
                title: 'Battery',
                value: '${product.fields.batteryCapacityMah} mAh',
              ),
            ),
            const SizedBox(height: 8.0),

            // Spesifikasi Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SpecificationRow(
                title: 'Display',
                value: '${product.fields.screenSizeInches}"',
              ),
            ),
            const SizedBox(height: 16.0),

            // Rating Angka
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Rating: ${averageRating.toStringAsFixed(1)}/5',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),

            // Bintang Rating
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: List.generate(5, (index) {
                  return _buildStar(index, averageRating);
                }),
              ),
            ),
            const SizedBox(height: 16.0),
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
      return const Icon(Icons.star, color: Colors.yellow, size: 24.0);
    } else if (index == fullStars && fractional >= 0.5) {
      return Stack(
        children: [
          const Icon(Icons.star_border, color: Colors.yellow, size: 24.0),
          ClipRect(
            clipper: HalfClipper(),
            child: const Icon(Icons.star, color: Colors.yellow, size: 24.0),
          ),
        ],
      );
    } else {
      return const Icon(Icons.star_border, color: Colors.yellow, size: 24.0);
    }
  }
}

class SpecificationRow extends StatelessWidget {
  final String title;
  final String value;

  const SpecificationRow({Key? key, required this.title, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Judul Spesifikasi
        SizedBox(
          width: 100, // Sesuaikan lebar sesuai kebutuhan
          child: Text(
            '$title:',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
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
