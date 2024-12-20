// lib/screens/review_page.dart

import 'package:flutter/material.dart';
import 'package:jaket_mobile/app_module/data/model/review.dart';
import 'package:jaket_mobile/auth_controller.dart';
import 'package:jaket_mobile/presentation/review/add_edit_review_page.dart';
import 'package:jaket_mobile/presentation/review/review_card.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  final String productId;

  const ReviewPage({Key? key, required this.productId}) : super(key: key);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late Future<List<Review>> _futureReviews;

  @override
  void initState() {
    super.initState();
    _futureReviews = fetchReviews();
  }

  Future<List<Review>> fetchReviews() async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final response = await authController.request.get(
      'http://10.0.2.2:8000/detail/list_review/${widget.productId}/',
    );

    if (response['status'] == 'success') {
      List<dynamic> reviewsJson = response['reviews'];
      return reviewsJson.map((json) => Review.fromJson(json)).toList();
    } else {
      throw Exception(response['message'] ?? 'Gagal memuat ulasan.');
    }
  }

  void _refreshReviews() {
    setState(() {
      _futureReviews = fetchReviews();
    });
  }

  void _navigateToAddReview() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditReviewPage(
          productId: widget.productId,
        ),
      ),
    );

    if (result == true) {
      _refreshReviews();
    }
  }

  void _navigateToEditReview(Review review) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditReviewPage(
          productId: widget.productId,
          review: review,
        ),
      ),
    );

    if (result == true) {
      _refreshReviews();
    }
  }

  void _deleteReview(int reviewId) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Review'),
        content: const Text('Apakah Anda yakin ingin menghapus review ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final authController = Provider.of<AuthController>(context, listen: false);
        final response = await authController.request.post(
          'http://10.0.2.2:8000/detail/delete_review_flutter/$reviewId/',
          {},
        );

        if (response['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Review berhasil dihapus.')),
          );
          _refreshReviews();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(response['message'] ?? 'Gagal menghapus review.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ulasan Produk'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshReviews,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => _refreshReviews(),
        child: FutureBuilder<List<Review>>(
          future: _futureReviews,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Belum ada ulasan.'));
            } else {
              return ListView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final review = snapshot.data![index];
                  return ReviewCard(
                    review: review,
                    onEdit: () => _navigateToEditReview(review),
                    onDelete: () => _deleteReview(review.id),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: authController.isLoggedIn
          ? FloatingActionButton(
              onPressed: _navigateToAddReview,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
