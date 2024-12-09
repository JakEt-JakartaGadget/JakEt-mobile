import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';

class AddArticlePage extends StatefulWidget {
  const AddArticlePage({Key? key}) : super(key: key);

  @override
  State<AddArticlePage> createState() => _AddArticlePageState();
}

class _AddArticlePageState extends State<AddArticlePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _sourceController = TextEditingController();
  final _contentController = TextEditingController();
  final _imageUrlController = TextEditingController();

  Future<void> submitArticle(CookieRequest request) async {
    if (_formKey.currentState!.validate()) {
      final response = await request.post(
        'http://127.0.0.1:8000/article/add/',
        {
          'title': _titleController.text,
          'source': _sourceController.text,
          'content': _contentController.text,
          'imageUrl': _imageUrlController.text,
        },
      );

      if (response["message"] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response["message"])),
        );
        Navigator.pop(context); // Navigasi kembali setelah artikel berhasil ditambahkan
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to add article: ${response["error"] ?? "Unknown error"}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Article'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Tombol kembali
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Form untuk Title
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the title';
                  }
                  return null;
                },
              ),
              
              // Form untuk Source
              TextFormField(
                controller: _sourceController,
                decoration: const InputDecoration(labelText: 'Source'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the source';
                  }
                  return null;
                },
              ),

              // Form untuk Content
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the content';
                  }
                  return null;
                },
              ),

              // Form untuk Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the image URL';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 20),
              
              // Tombol Submit
              ElevatedButton(
                onPressed: () => submitArticle(request),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
