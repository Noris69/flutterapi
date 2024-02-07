// home_screen.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled6/screens/article_detail_screen.dart';
import 'package:untitled6/components/news_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> newsData = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final Uri apiUrl = Uri.parse(
        'https://newsapi.org/v2/everything?domains=wsj.com&apiKey=b667000cd4c748b3a89819447203df8c');
    final response = await http.get(apiUrl);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        newsData = data['articles'];
      });
    } else {
      throw Exception('Failed to load news');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News App'),
      ),
      body: NewsList(
        newsData: newsData,
        onTap: (index) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArticleDetailScreen(
                article: newsData[index],
              ),
            ),
          );
        },
      ),
    );
  }
}
