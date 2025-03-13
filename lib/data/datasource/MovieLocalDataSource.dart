import 'dart:ui';

import 'package:movie_app/model/User.dart';
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
      onCreate: (db, version) async {
         // Tạo bảng favorite_movies có khóa ngoại user_id
      await db.execute('''
        CREATE TABLE favorite_movies(
          id TEXT,
          user_id INTEGER,
          _name TEXT,
          _slug TEXT,
          _originName TEXT,
          _type TEXT,
          _posterUrl TEXT,
          _thumbUrl TEXT,
          _subDocQuyen INTEGER,
          _chieuRap INTEGER,
          _time TEXT,
          _episodeCurrent TEXT,
          _qualiry TEXT,
          _lang TEXT,
          _year INTEGER,
          PRIMARY KEY (user_id, id),
          FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
        )
      ''');

        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT,
          email TEXT UNIQUE,
          password TEXT
        )
      ''');
      },
    );
  }

  Future<void> insertMovie(int userId,Movies movie) async {
    final db = await database;

    final userExists = await db.query('users', where: 'id = ?', whereArgs: [userId]);
    if (userExists.isEmpty) {
      throw Exception("User không tồn tại");
    }

    print("User Check:::$userExists");

    await db.insert(tableName, {
      'id': movie.id,
      'user_id': userId,
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

  Future<List<Movies>> getFavoriteMovies(int userId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_movies',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    return maps.map((movieMap) => Movies.fromMap(movieMap)).toList();
  }

  Future<void> deleteMovie(int userId, String movieId) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ? AND user_id = ?',
      whereArgs: [movieId, userId], // Chỉ xóa phim của đúng user
    );
  }


  Future<bool> isFavorite(int userId, String movieId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'favorite_movies',
      where: 'user_id = ? AND id = ?',
      whereArgs: [userId, movieId],
    );
    return maps.isNotEmpty;
  }

  //User
  Future<User?> registerUser(String username,String email, String password) async {
    final db = await database;
     int rs =  await db.insert('users', {
      'username': username,
       'email':email,
      'password': password,
    });

     if(rs!=0){
       User? user = await this.findUserByEmail(email);
       return user;
     }
     return null;
  }

  Future<User?> findUserByEmail(String email) async{
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    if(result.isNotEmpty){
      return User.fromMap(result.first);
    }
    return null;
  }

}