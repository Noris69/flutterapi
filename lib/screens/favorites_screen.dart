// favorites_screen.dart
import 'package:flutter/material.dart';
import 'package:untitled6/database/database_helper.dart';
import 'package:untitled6/screens/article_detail_screen.dart';

class FavoritesScreen extends StatefulWidget {
  @override
  _FavoritesScreenState createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  late Future<List<Article>> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture = DatabaseHelper.instance.getAllFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favoris'),
      ),
      body: FutureBuilder<List<Article>>(
        future: _favoritesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Erreur lors du chargement des favoris.'),
            );
          } else {
            final favorites = snapshot.data!;
            if (favorites.isEmpty) {
              return Center(
                child: Text('Aucun article en favoris.'),
              );
            } else {
              return ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final article = favorites[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        article.title,
                        style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        article.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArticleDetailScreen(article: {
                              'title': article.title,
                              'description': article.description,
                              'urlToImage': article.imageUrl,
                              'author': article.author, // Pass the author's name
                              'publishedAt': article.publishedAt, // Pass the publication date
                            }),
                          ),
                        ).then((value) {
                          setState(() {
                            _favoritesFuture = DatabaseHelper.instance.getAllFavorites();
                          });
                        });
                      },
                      trailing: IconButton(
                        icon: Icon(Icons.favorite , color: Colors.red),
                        onPressed: () async {
                          await DatabaseHelper.instance.delete(article.title);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Article retiré des favoris'),
                          ));
                          setState(() {
                            _favoritesFuture = DatabaseHelper.instance.getAllFavorites();
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }
}
