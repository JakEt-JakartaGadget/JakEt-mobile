import 'package:flutter/material.dart';
import 'package:jaket_mobile/presentation/article/article_add.dart';
import 'package:jaket_mobile/presentation/article/article_detail.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:jaket_mobile/presentation/article/models/article_entry.dart';

class ArticleListPage extends StatefulWidget {
  const ArticleListPage({Key? key}) : super(key: key);

  @override
  State<ArticleListPage> createState() => _ArticleListPageState();
}

class _ArticleListPageState extends State<ArticleListPage> {
  Future<List<Artikel>> fetchArticles(CookieRequest request) async {
    // Ganti URL dengan endpoint API Django yang sesuai
    final response = await request.get('http://127.0.0.1:8000/article/json/');
    List<dynamic> data = response;  // Mengambil response JSON

    // Konversi data JSON menjadi list objek Artikel
    List<Artikel> articleList = [];
    for (var d in data) {
      if (d != null) {
        articleList.add(Artikel.fromJson(d));
      }
    }
    return articleList;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddArticlePage()),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Artikel>>(
        future: fetchArticles(request),
        builder: (context, AsyncSnapshot<List<Artikel>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No articles available.',
                style: TextStyle(fontSize: 18, color: Color(0xff59A5D8)),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (_, index) {
                final article = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ArticleDetailPage(
                          artikel: article,
                          title: article.fields.title,
                          content: article.fields.content,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          article.fields.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.fields.source,
                          style: const TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article.fields.content.length > 50
                              ? '${article.fields.content.substring(0, 50)}...'
                              : article.fields.content,
                          style: const TextStyle(fontSize: 14.0),
                        ),
                        const SizedBox(height: 8),
                        // Memastikan imageUrl ada atau tidak
                        article.fields.imageUrl.isNotEmpty
                            ? Image.network(
                                article.fields.imageUrl,
                                height: 150,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.image, size: 150, color: Colors.grey),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
