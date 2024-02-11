import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:untitled6/screens/article_detail_screen.dart';
import 'package:untitled6/database/database_helper.dart';
import 'package:untitled6/screens/favorites_screen.dart';

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
        leading: Padding(
          padding: EdgeInsets.only(left: 12.0), // Ajouter un espacement de 8.0 à gauche de l'image
          child: Image.asset('assets/logo.png'), // Charger le logo depuis les ressources
        ),
        title: Text(
          'DAILY NEWS API',
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavoritesScreen()),
              ).then((_) {
                fetchData(); // Re-fetch data after returning from favorites screen
              });
            },
          ),
        ],
      ),

      body: ListView.builder(
        itemCount: newsData.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailScreen(
                      article: newsData[index],
                    ),
                  ),
                ).then((isFavorite) {
                  if (isFavorite != null) {
                    // Mettre à jour la liste des données si l'état des favoris a été modifié
                    fetchData();
                  }
                });
              },
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(
                    color: Colors.black, // Couleur de la bordure
                    width: 1, // Épaisseur de la bordure
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newsData[index]['title'] ?? '',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8),
                            Text(
                              newsData[index]['description'] ?? '',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: FutureBuilder<bool>(
                          future: DatabaseHelper.instance.isArticleInFavorites(newsData[index]['title']),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final isFavorite = snapshot.data!;
                              return Icon(
                                isFavorite ? Icons.favorite : Icons.favorite_border,
                                color: isFavorite ? Colors.red : Colors.grey,
                              );
                            } else {
                              return SizedBox.shrink();
                            }
                          },
                        ),
                        onPressed: () async {
                          final title = newsData[index]['title'];
                          if (title != null && newsData[index].containsKey('title')) {
                            final isFavorite = await DatabaseHelper.instance.isArticleInFavorites(title);
                            if (isFavorite) {
                              await DatabaseHelper.instance.delete(title);
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Article retiré des favoris'),
                              ));
                            } else {
                              await DatabaseHelper.instance.insert(
                                Article(
                                  title: newsData[index]['title'] ?? '',
                                  description: newsData[index]['description'] ?? '',
                                  imageUrl: newsData[index]['urlToImage'] ?? '',
                                  publishedAt: newsData[index]['publishedAt'] ?? '',
                                  author: newsData[index]['author'] ?? '',
                                ),
                              );
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text('Article ajouté aux favoris'),
                              ));
                            }
                            setState(() {});
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),

            ),
          );
        },
      ),
    );
  }
}
