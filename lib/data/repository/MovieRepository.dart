
import '../../model/Movies.dart';
import '../../model/User.dart';

abstract class MovieRepository{
  Future<void> addToFavorites(int userId,Movies movie);
  Future<void> removeFromFavorites(int userId,String movieId);
  Future<List<Movies>> getFavoriteMovies(int userId);
  Future<bool> isFavorite(int userId,String movieId);
  Future<User?> getUserByEmail(String email);
  Future<User?> createUser(User user);
}