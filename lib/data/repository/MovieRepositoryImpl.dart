import 'package:movie_app/data/Movies.dart';

import '../datasource/MovieLocalDataSource.dart';
import 'MovieRepository.dart';

class MovieRepositoryImpl implements MovieRepository{

  MovieLocalDataSource database;

  MovieRepositoryImpl(this.database);

  @override
  Future<void> addToFavorites(Movies movie) async {
    database.insertMovie(movie);
  }

  @override
  Future<List<Movies>> getFavoriteMovies() {
    return database.getFavoriteMovies();
  }

  @override
  Future<void> removeFromFavorites(String movieId) async {
    database.deleteMovie(movieId);
  }

  @override
  Future<bool> isFavorite(String movieId) {
    return database.isFavorite(movieId);
  }
  
}