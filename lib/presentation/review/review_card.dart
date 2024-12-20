import 'package:flutter/material.dart';
import 'package:jaket_mobile/app_module/data/model/review.dart';

class ReviewCard extends StatefulWidget {
  final Review review;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  const ReviewCard({
    Key? key,
    required this.review,
    this.onEdit,
    this.onDelete,
  }) : super(key: key);

  @override
  _ReviewCardState createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  bool isExpanded = false;
  static const int maxContentLength = 100; // Panjang maksimum sebelum View More muncul

  // Fungsi untuk membangun bintang berdasarkan rating
  List<Widget> buildStarRating(int rating) {
    List<Widget> stars = [];
    for (int i = 1; i <= 5; i++) {
      if (i <= rating) {
        stars.add(const Icon(
          Icons.star,
          color: Colors.amber,
          size: 20.0,
        ));
      } else {
        stars.add(const Icon(
          Icons.star_border,
          color: Colors.amber,
          size: 20.0,
        ));
      }
    }
    return stars;
  }

  @override
  Widget build(BuildContext context) {
    // Hanya menampilkan opsi edit dan delete jika ada callback
    bool showEditDelete = widget.onEdit != null && widget.onDelete != null;

    // Cek apakah konten ulasan perlu dipersingkat
    String displayContent = widget.review.content;
    bool showViewMoreButton = widget.review.content.length > maxContentLength;

    if (!isExpanded && showViewMoreButton) {
      displayContent = widget.review.content.substring(0, maxContentLength) + '...';
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ikon Profil dengan Icon default atau gambar pengguna
            CircleAvatar(
              radius: 24,
              backgroundImage: widget.review.user.profileImageUrl.isNotEmpty
                  ? NetworkImage(widget.review.user.profileImageUrl)
                  : null, // Jika ada gambar, tampilkan
              child: widget.review.user.profileImageUrl.isEmpty
                  ? const Icon(Icons.person, color: Colors.white, size: 24)
                  : null, // Jika tidak ada, tampilkan ikon
              backgroundColor: widget.review.user.profileImageUrl.isEmpty ? Colors.grey : null,
            ),
            const SizedBox(width: 12.0),
            // Kolom dengan Username, Rating, dan Konten Ulasan
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Username dan Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.review.user.username,
                        style: const TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Rating Bintang
                      Row(
                        children: buildStarRating(widget.review.rating),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  // Konten Ulasan
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayContent,
                        style: const TextStyle(
                          fontSize: 14.0,
                          color: Colors.black87,
                        ),
                      ),
                      if (showViewMoreButton) 
                        TextButton(
                          onPressed: () {
                            setState(() {
                              isExpanded = !isExpanded;
                            });
                          },
                          child: Text(
                            isExpanded ? 'Hide' : 'View More',
                            style: const TextStyle(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.review.dateAdded,
                        style: const TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      if (showEditDelete)
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: widget.onEdit,
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: widget.onDelete,
                            ),
                          ],
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
