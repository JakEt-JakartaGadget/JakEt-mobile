import 'package:flutter/material.dart';
import 'package:jaket_mobile/app_module/data/model/review.dart';
import 'package:jaket_mobile/auth_controller.dart';
import 'package:jaket_mobile/presentation/review/review_card.dart';
import 'package:provider/provider.dart';

class ReviewList extends StatefulWidget {
  final String productId;
  final List<Review> reviews;
  final Map<int, int> ratingCounts;
  final Function onReviewChanged;

  const ReviewList({
    Key? key,
    required this.productId,
    required this.reviews,
    required this.ratingCounts,
    required this.onReviewChanged,
  }) : super(key: key);

  @override
  _ReviewListState createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList> {
  int? _selectedFilter;

  List<Review> get _filteredReviews {
    if (_selectedFilter != null) {
      return widget.reviews.where((review) => review.rating == _selectedFilter).toList();
    }
    return widget.reviews;
  }

  void _applyFilter(int? rating) {
    setState(() {
      _selectedFilter = rating;
    });
  }

  Future<void> _showAddEditReviewDialog({Review? review}) async {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUsername = authController.username;
    final isEditing = review != null;

    String content = isEditing ? review.content : '';
    int rating = isEditing ? review.rating : 5;

    final _formKey = GlobalKey<FormState>();
    bool _isLoading = false;

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Ulasan' : 'Tambah Ulasan'),
              content: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Align(
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                'Rating:',
                                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: List.generate(5, (index) {
                                return IconButton(
                                  icon: Icon(
                                    index < rating ? Icons.star : Icons.star_border,
                                    color: index < rating ? Colors.amber : Colors.grey,
                                  ),
                                  onPressed: () {
                                    setStateDialog(() {
                                      rating = index + 1;
                                    });
                                  },
                                );
                              }),
                            ),
                            const SizedBox(height: 16.0),
                            TextFormField(
                              initialValue: content,
                              decoration: const InputDecoration(
                                labelText: 'Ulasan',
                                border: OutlineInputBorder(),
                              ),
                              maxLines: 5,
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Ulasan tidak boleh kosong.';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                content = value!.trim();
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
              actions: _isLoading
                  ? []
                  : [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) return;

                          _formKey.currentState!.save();

                          setStateDialog(() {
                            _isLoading = true;
                          });

                          try {
                            bool success;
                            if (isEditing) {
                              success = await authController.editReview(
                                review!.id,
                                content: content,
                                rating: rating,
                              );
                              if (success) {
                                widget.onReviewChanged();
                              }
                            } else {
                              success = await authController.addReview(widget.productId, content, rating);
                              if (success) {
                                widget.onReviewChanged();
                              }
                            }

                            if (success) {
                              widget.onReviewChanged();
                              Navigator.pop(context);
                            }
                          } catch (e) {
                          } finally {
                            setStateDialog(() {
                              _isLoading = false;
                            });
                          }
                        },
                        child: Text(isEditing ? 'Perbarui' : 'Tambah'),
                      ),
                    ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context, listen: false);
    final currentUsername = authController.username;
    bool hasUserReview = widget.reviews.any((review) => review.user.fields.username == currentUsername);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(5, (index) {
                final star = index + 1; 
                final isSelected = _selectedFilter == star;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$star',
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        _applyFilter(star);
                      } else {
                        _applyFilter(null);
                      }
                    },
                    selectedColor: const Color(0xFF6D0CC9),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 16.0),
          if (authController.isLoggedIn && !hasUserReview)
            ElevatedButton(
              onPressed: () => _showAddEditReviewDialog(),
              child: const Text('Tambah Ulasan'),
            ),
          const SizedBox(height: 16.0),
          _filteredReviews.isEmpty
              ? 
              const Column(
                children: [
                  Text('Tidak ada ulasan dengan rating ini.'),
                  SizedBox(height: 10,)
                ],
              )
              
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: _filteredReviews.length,
                  itemBuilder: (context, index) {
                    final review = _filteredReviews[index];
                    final isOwner = authController.isLoggedIn && review.user.fields.username == currentUsername;

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: ReviewCard(
                        review: review,
                        onEdit: isOwner
                            ? () => _showAddEditReviewDialog(review: review)
                            : null,
                        onDelete: isOwner
                            ? () async {
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
                                    bool success = await authController.deleteReview(review.id);
                                    if (success) {
                                      widget.onReviewChanged();
                                    }
                                  } catch (e) {
                                  }
                                }
                              }
                            : null,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
