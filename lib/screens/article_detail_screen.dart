import 'package:flutter/material.dart';
import 'package:untitled6/database/database_helper.dart';

class ArticleDetailScreen extends StatefulWidget {
  final dynamic article;

  ArticleDetailScreen({required this.article});

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    checkFavorite();
  }

  void checkFavorite() async {
    bool favorite = await DatabaseHelper.instance.isArticleInFavorites(widget.article['title']);
    setState(() {
      isFavorite = favorite;
    });
  }

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
            Visibility(
              visible: widget.article['urlToImage'] != null,
              child: Image.network(widget.article['urlToImage'] ?? ''),
            ),
            SizedBox(height: 16.0),
            Text(
              widget.article['title'] ?? '',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              widget.article['author'] ?? '',
              style: TextStyle(fontSize: 14.0, fontStyle: FontStyle.italic),
            ),
            SizedBox(height: 8.0),
            Text(widget.article['description'] ?? ''),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (isFavorite) {
                  await DatabaseHelper.instance.delete(widget.article['title']);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Article retiré des favoris'),
                  ));
                } else {
                  await DatabaseHelper.instance.insert(
                    Article(
                      title: widget.article['title'] ?? '',
                      description: widget.article['description'] ?? '',
                      imageUrl: widget.article['urlToImage'] ?? '',
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text('Article ajouté aux favoris'),
                  ));
                }
                setState(() {
                  isFavorite = !isFavorite;
                });
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
                  return isFavorite ? Colors.red : Colors.grey; // Couleur du bouton en fonction de l'état de favoris
                }),
              ),
              child: Text(isFavorite ? 'Retirer des favoris' : 'Ajouter aux favoris', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
