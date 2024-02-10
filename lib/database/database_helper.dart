import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Article {
  final String title;
  final String description;
  final String imageUrl;
  final String publishedAt; // New field
  final String author; // New field

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.publishedAt,
    required this.author, // Added the author field
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'publishedAt': publishedAt,
      'author': author, // Added the author field
    };
  }
}

class DatabaseHelper {
  static final _databaseName = "news.db";
  static final _databaseVersion = 1;

  static final table = 'favorites';

  static final columnId = 'id';
  static final columnTitle = 'title';
  static final columnDescription = 'description';
  static final columnImageUrl = 'imageUrl';
  static final columnPublishedAt = 'publishedAt';
  static final columnAuthor = 'author'; // New field

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnImageUrl TEXT NOT NULL,
        $columnPublishedAt TEXT NOT NULL,
        $columnAuthor TEXT NOT NULL 
      )
    ''');
  }

  Future<int> insert(Article article) async {
    Database db = await instance.database;
    return await db.insert(table, article.toMap());
  }

  Future<List<Article>> getAllFavorites() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return Article(
        title: maps[i][columnTitle],
        description: maps[i][columnDescription],
        imageUrl: maps[i][columnImageUrl],
        publishedAt: maps[i][columnPublishedAt],
        author: maps[i][columnAuthor], // Retrieve the author field
      );
    });
  }

  Future<void> delete(String title) async {
    Database db = await instance.database;
    await db.delete(table, where: '$columnTitle = ?', whereArgs: [title]);
  }

  // New method to check if an article is in favorites
  Future<bool> isArticleInFavorites(String title) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> maps = await db.query(
      table,
      where: '$columnTitle = ?',
      whereArgs: [title],
    );
    return maps.isNotEmpty;
  }
}
