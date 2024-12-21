import 'package:flutter/material.dart';
import 'package:jaket_mobile/app_module/data/model/review.dart';
import 'package:jaket_mobile/auth_controller.dart';
import 'package:provider/provider.dart';

class AddEditReviewPage extends StatefulWidget {
  final String productId;
  final Review? review; 

  const AddEditReviewPage({Key? key, required this.productId, this.review}) : super(key: key);

  @override
  _AddEditReviewPageState createState() => _AddEditReviewPageState();
}

class _AddEditReviewPageState extends State<AddEditReviewPage> {
  final _formKey = GlobalKey<FormState>();
  String _content = '';
  int _rating = 5;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.review != null) {
      _content = widget.review!.content;
      _rating = widget.review!.rating;
    }
  }

  void _submitReview() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final authController = Provider.of<AuthController>(context, listen: false);

    try {
      bool success;
      if (widget.review == null) {
        success = await authController.addReview(widget.productId, _content, _rating);
      } else {
        success = await authController.editReview(widget.review!.id, content: _content, rating: _rating);
      }

      if (success) {
        Navigator.pop(context, true); // Kembali dengan hasil sukses
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan ulasan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
      print('Error submitting review: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String get _title => widget.review == null ? 'Tambah Ulasan' : 'Edit Ulasan';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rating:',
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8.0),
                      Row(
                        children: List.generate(5, (index) {
                          return IconButton(
                            icon: index < _rating
                                ? const Icon(Icons.star, color: Colors.amber)
                                : const Icon(Icons.star_border, color: Colors.amber),
                            onPressed: () {
                              setState(() {
                                _rating = index + 1;
                              });
                            },
                          );
                        }),
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        initialValue: _content,
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
                          _content = value!.trim();
                        },
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitReview,
                          child: Text(widget.review == null ? 'Tambah' : 'Perbarui'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
