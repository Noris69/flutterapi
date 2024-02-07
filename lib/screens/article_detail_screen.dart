// article_detail_screen.dart
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatelessWidget {
  final dynamic article;

  ArticleDetailScreen({required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article Detail'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(article['urlToImage'] ?? ''),
            SizedBox(height: 16.0),
            Text(
              article['title'] ?? '',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              article['author'] ?? '',
              style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8.0),
            Text(article['content'] ?? ''),
          ],
        ),
      ),
    );
  }
}