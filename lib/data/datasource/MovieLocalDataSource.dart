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
          'CREATE TABLE $tableName(id TEXT PRIMARY KEY, _name TEXT, _slug TEXT, _originName TEXT, _type TEXT, _posterUrl TEXT, _thumbUrl TEXT, _subDocQuyen INTEGER, _chieuRap INTEGER, _time TEXT, _episodeCurrent TEXT, _qualiry TEXT, _lang TEXT, _year INTEGER)',
        );
      },
    );
  }

  Future<void> insertMovie(Movies movie) async {
    final db = await database;
    await db.insert(tableName, {
      'id': movie.id,
      '_name': movie.name,
      '_slug': movie.slug,
      '_originName': movie.originName,
      '_type': movie.type,
      '_posterUrl': movie.posterUrl,
      '_thumbUrl': movie.thumbUrl,
      '_subDocQuyen': movie.subDocQuyen,
      '_chieuRap': movie.chieuRap,
      '_time': movie.time,
      '_episodeCurrent': movie.episodeCurrent,
      '_qualiry': movie.qualiry,
      '_lang': movie.lang,
      '_year': movie.year
    });
  }

  Future<List<Movies>> getFavoriteMovies() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    return maps.map((movieMap) => Movies.fromMap(movieMap)).toList();
  }

  Future<void> deleteMovie(String movieId) async {
    final db = await database;
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