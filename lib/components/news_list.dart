// news_list.dart
import 'package:flutter/material.dart';

class NewsList extends StatelessWidget {
  final List<dynamic> newsData;
  final Function(int) onTap;

  NewsList({required this.newsData, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: newsData.length,
      itemBuilder: (context, index) {
        final article = newsData[index];
        return ListTile(
          title: Text(article['title']),
          subtitle: Text(article['description'] ?? ''),
          onTap: () => onTap(index),
        );
      },
    );
  }
}

