import 'package:movie_app/data/Movies.dart';

abstract class MovieRepository{
  Future<void> addToFavorites(Movies movie);
  Future<void> removeFromFavorites(String movieId);
  Future<List<Movies>> getFavoriteMovies();
  Future<bool> isFavorite(String movieId);
}