import 'package:flutter/material.dart';
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
  late Future<List<Artikel>> _articleFuture;

  @override
  void initState() {
    super.initState();
    _articleFuture = fetchArticles(context.read<CookieRequest>());
  }

  Future<List<Artikel>> fetchArticles(CookieRequest request) async {
    try {
      final response = await request.get('http://127.0.0.1:8000/article/json/');
      List<dynamic> data = response;
      return data.map((json) => Artikel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to fetch articles: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article List'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Artikel>>(
        future: _articleFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _articleFuture = fetchArticles(context.read<CookieRequest>());
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
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
              itemBuilder: (context, index) {
                final article = snapshot.data![index];
                return ArticleListItem(article: article);
              },
            );
          }
        },
      ),
    );
  }
}

class ArticleListItem extends StatelessWidget {
  final Artikel article;

  const ArticleListItem({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            // Handle image
            article.fields.imageUrl.isNotEmpty
                ? Image.network(
                    article.fields.imageUrl,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.broken_image, size: 150, color: Colors.grey);
                    },
                  )
                : const Icon(Icons.image, size: 150, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
