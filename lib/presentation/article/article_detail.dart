import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/article/models/article_entry.dart';


class ArticleDetailPage extends StatelessWidget {
  final Artikel artikel;

  // Constructor untuk menerima data artikel
  ArticleDetailPage({required this.artikel, required String title, required String content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(artikel.fields.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Menampilkan gambar artikel
              artikel.fields.imageUrl.isNotEmpty
                  ? Image.network(artikel.fields.imageUrl)
                  : Icon(Icons.image, size: 200),
              SizedBox(height: 10),
              // Menampilkan judul artikel
              Text(
                artikel.fields.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // Menampilkan tanggal publikasi
              Text(
                'Published on: ${artikel.fields.publishedDate.toLocal().toString()}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 10),
              // Menampilkan konten artikel
              Text(
                artikel.fields.content,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              // Menampilkan sumber artikel
              Text(
                'Source: ${artikel.fields.source}',
                style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
