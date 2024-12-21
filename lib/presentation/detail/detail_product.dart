import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jaket_mobile/presentation/authentication/login.dart';
import 'package:jaket_mobile/presentation/detail/spesification.dart';
import 'package:jaket_mobile/presentation/review/review_list.dart';
import 'package:provider/provider.dart';
import 'package:jaket_mobile/auth_controller.dart';
import 'package:jaket_mobile/app_module/data/model/review.dart';

class HalfClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(0, 0, size.width / 2, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) => false;
}

class ProductDetailPage extends StatefulWidget {
  final ProductEntry product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  int totalVotes = 0;
  double averageRating = 0.0;
  late NumberFormat formatter;
  late AuthController authController;

  Map<int, int> ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

  List<Review> reviews = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    formatter = NumberFormat.decimalPattern('id_ID');
    authController = Provider.of<AuthController>(context, listen: false);
    _fetchAndCalculateRatings();
  }

  Future<void> _fetchAndCalculateRatings() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fetchedReviews =
          await authController.fetchReviews(widget.product.pk);

      setState(() {
        reviews = fetchedReviews;
        ratingCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

        for (var review in reviews) {
          if (ratingCounts.containsKey(review.rating)) {
            ratingCounts[review.rating] = ratingCounts[review.rating]! + 1;
          }
        }

        totalVotes = ratingCounts.values.reduce((a, b) => a + b);
        totalVotes += widget.product.fields.oneStar +
            widget.product.fields.twoStar +
            widget.product.fields.threeStar +
            widget.product.fields.fourStar +
            widget.product.fields.fiveStar;

        if (totalVotes > 0) {
          averageRating = ((ratingCounts.entries
                  .map((e) => e.key * e.value)
                  .reduce((a, b) => a + b)) +
              1 * widget.product.fields.oneStar +
              2 * widget.product.fields.twoStar +
              3 * widget.product.fields.threeStar +
              4 * widget.product.fields.fourStar +
              5 * widget.product.fields.fiveStar) / totalVotes;
          print(averageRating);
        } else {
          averageRating = 0.0;
        }
      });
    } catch (e) {
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildStar(int index, double rating) {
    int fullStars = rating.floor();
    double fractional = rating - fullStars;

    if (index < fullStars) {
      return const Icon(Icons.star, color: Colors.yellow, size: 20.0);
    } else if (index == fullStars && fractional >= 0.5) {
      return Stack(
        children: [
          const Icon(Icons.star_border, color: Colors.yellow, size: 20.0),
          ClipRect(
            clipper: HalfClipper(),
            child: const Icon(Icons.star, color: Colors.yellow, size: 20.0),
          ),
        ],
      );
    } else {
      return const Icon(Icons.star, color: Colors.grey, size: 20.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFavorite = authController.isProductFavorite(widget.product.pk);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _fetchAndCalculateRatings,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    widget.product.fields.imageUrl,
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error, color: Colors.red, size: 50),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 16,
                    child: CircleAvatar(
                      minRadius: 18,
                      maxRadius: 19,
                      backgroundColor: Colors.black54,
                      child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 16,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Rp.${formatter.format(widget.product.fields.priceInr ?? 0)},00',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF6D0CC9),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        if (authController.isLoggedIn) {
                          bool success;
                          if (isFavorite) {
                            success = await authController
                                .removeFromFavorites(widget.product.pk);
                            if (success) {
                              // Anda bisa menambahkan aksi setelah berhasil menghapus favorit
                            } else {
                              // Anda bisa menambahkan aksi jika gagal menghapus favorit
                            }
                          } else {
                            success = await authController
                                .addToFavorites(widget.product.pk);
                            if (success) {
                            } else {}
                          }
                          setState(() {});
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Silakan login untuk menandai favorit.')),
                          );
                          Get.to(const LoginPage());
                        }
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color:
                            isFavorite ? Colors.red : const Color(0xFF6D0CC9),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${widget.product.fields.brand} ${widget.product.fields.model}',
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'One of the outstanding outcomes from ${widget.product.fields.brand} is ${widget.product.fields.model}. This phone is a great choice for those who are looking for a phone with a good camera, large storage, and long battery life. Which comes with ${widget.product.fields.ram} GB RAM and ${widget.product.fields.storage} GB storage.',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Specification',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SpecificationRow(
                  title: 'Camera',
                  value: widget.product.fields.cameraMp.toString(),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SpecificationRow(
                  title: 'Storage',
                  value: widget.product.fields.storage.toString(),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SpecificationRow(
                  title: 'Battery',
                  value: '${widget.product.fields.batteryCapacityMah} mAh',
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SpecificationRow(
                  title: 'Display',
                  value: '${widget.product.fields.screenSizeInches}" pixels',
                ),
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Text(
                      'Rating: ${averageRating.toStringAsFixed(1)}/5',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Icon(
                      Icons.person,
                      size: 16,
                      color: Colors.grey[700],
                    ),
                    Text(
                      totalVotes.toString(),
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: List.generate(5, (index) {
                    return _buildStar(index, averageRating);
                  }),
                ),
              ),
              const SizedBox(height: 8.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ulasan Produk',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              ReviewList(
                productId: widget.product.pk,
                reviews: reviews,
                ratingCounts: ratingCounts,
                onReviewChanged: _fetchAndCalculateRatings,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
