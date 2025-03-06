
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/data/repository/MovieRepository.dart';

import '../addFavorite/FavoriteRequest.dart';
import '../addFavorite/FavoriteResponse.dart';

class RemoveFavoriteMovieUseCase implements InputBoundary{

  final OutputBoundary _presenter;
  final MovieRepository repository;
  RemoveFavoriteMovieUseCase(this._presenter, this.repository);

  @override
  execute(RequestData request) async {
    try {
      final data = (request as FavoriteRequest);
      final movie = data.movie;

      await repository.removeFromFavorites(movie.id);
      // print(movie.id);

      _presenter.execute(FavoriteResponse(
          success: true,
          message: "Movie remove to favorites"));
    } catch (e) {
      _presenter.execute(FavoriteResponse(
          success: false,
          message: e.toString()
      ));
    }
  }
}