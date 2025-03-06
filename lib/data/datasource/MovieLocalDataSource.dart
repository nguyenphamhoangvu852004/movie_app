import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../model/Movies.dart';

class MovieLocalDataSource{
  static const String tableName = "favorite_movies";
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'movies.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE $tableName(id TEXT PRIMARY KEY, _name TEXT, _posterUrl TEXT)',
        );
      },
    );
  }

  Future<void> insertMovie(Movies movie) async {
    final db = await database;
    await db.insert(tableName, {
      'id': movie.id,
      '_name': movie.name,
      '_posterUrl': movie.posterUrl,
    });
  }

  Future<List<Movies>> getFavoriteMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return maps.map((movieMap) => Movies.fromMap(movieMap)).toList();
  }

  Future<void> deleteMovie(String movieId) async {
    final db = await database;
    // print(movieId);
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [movieId], // Avoid SQL Injection
    );
  }

  Future<bool> isFavorite(String movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      tableName,
      where: 'id = ?',
      whereArgs: [movieId],
    );
    return maps.isNotEmpty;
  }

}