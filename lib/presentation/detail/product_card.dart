import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:jaket_mobile/app_module/data/model/product_entry.dart';
import 'package:jaket_mobile/presentation/detail/detail_product.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final ProductEntry product;

  const ProductCard({Key? key, required this.product}) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkIfFavorite();
    });
  }

  Future<void> _checkIfFavorite() async {
    final request = context.read<CookieRequest>();
    final url = "http://10.0.2.2:8000/wishlist/wish_json/";
    final response = await request.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final productId = widget.product.pk;
      final exists = (data as List).any((phone) => phone['pk'] == productId);

      setState(() {
        _isFavorite = exists;
      });
    } else {
    }
  }

Future<void> _toggleFavorite() async {
  final request = context.read<CookieRequest>();
  final productId = widget.product.pk.toString();

  if (_isFavorite) {
    final url = "http://10.0.2.2:8000/wishlist/remove_flutter/$productId/";
    final cookies = request.cookies.entries.map((e) => '${e.key}=${e.value}').join('; ');
    final response = await http.delete(
      Uri.parse(url),
      headers: {
        "Cookie": cookies,
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        _isFavorite = false;
      });
      await _checkIfFavorite(); 
    } else {
    }
  } else {
    final url = "http://10.0.2.2:8000/wishlist/add_to_favorite_flutter/";
    final response = await request.postJson(
      url,
      jsonEncode({"phone_id": productId}),
    );

    if (response['status'] == 'success' || response['status'] == 'info' || response['status'] == null) {
      setState(() {
        _isFavorite = true;
      });
      await _checkIfFavorite(); 
    } else {
    }
  }
}


  @override
  Widget build(BuildContext context) {
    final fields = widget.product.fields;
    final price = double.tryParse(fields.priceInr) ?? 0.0;
    final formatter = NumberFormat.decimalPattern('id_ID');

    int totalVotes = fields.oneStar + fields.twoStar + fields.threeStar + fields.fourStar + fields.fiveStar;
    double averageRating = totalVotes > 0
        ? (1 * fields.oneStar +
            2 * fields.twoStar +
            3 * fields.threeStar +
            4 * fields.fourStar +
            5 * fields.fiveStar) /
            totalVotes
        : 0;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ProductDetailPage(),
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
                  fields.imageUrl,
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
                    '${fields.brand} ${fields.model}',
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
                  onPressed: _toggleFavorite,
                  iconSize: 13.0,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : const Color(0xFF6D0CC9),
                    size: 16.0,
                  ),
                ),
              ],
            ),
            Text(
              'Storage: ${fields.storage}, Memory: ${fields.ram}',
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
              'Rp.${formatter.format(price)}',
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
