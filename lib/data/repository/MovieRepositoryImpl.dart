
import 'package:movie_app/model/User.dart';

import '../../model/Movies.dart';
import '../datasource/MovieLocalDataSource.dart';
import 'MovieRepository.dart';

class MovieRepositoryImpl implements MovieRepository{

  MovieLocalDataSource database;

  MovieRepositoryImpl(this.database);

  @override
  Future<void> addToFavorites(int userId,Movies movie) async {
    database.insertMovie(userId,movie);
  }

  @override
  Future<List<Movies>> getFavoriteMovies(int userId) {
    return database.getFavoriteMovies(userId);
  }

  @override
  Future<void> removeFromFavorites(int userId,String movieId) async {
    database.deleteMovie(userId,movieId);
  }

  @override
  Future<bool> isFavorite(int userId,String movieId) {
    return database.isFavorite(userId,movieId);
  }

  @override
  Future<User?> getUserByEmail(String email) {
    return database.findUserByEmail(email);
  }

  @override
  Future<User?> createUser(User user)  {
    return  database.registerUser(user.username,user.email, user.password);
  }
  
}