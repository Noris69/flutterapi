// database_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Article {
  final String title;
  final String description;
  final String imageUrl;

  Article({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
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
        $columnTitle TEXT PRIMARY KEY,
        $columnDescription TEXT NOT NULL,
        $columnImageUrl TEXT NOT NULL
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
      );
    });
  }

  Future<void> delete(String title) async {
    Database db = await instance.database;
    await db.delete(table, where: '$columnTitle = ?', whereArgs: [title]);
  }

  // Nouvelle méthode pour vérifier si un article est présent dans les favoris
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
