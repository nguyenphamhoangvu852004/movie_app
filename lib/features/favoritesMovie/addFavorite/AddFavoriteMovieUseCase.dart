
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/data/repository/MovieRepository.dart';

import 'FavoriteRequest.dart';
import 'FavoriteResponse.dart';

class AddFavoriteMovieUseCase implements InputBoundary{

  final OutputBoundary _presenter;
  final MovieRepository repository;
  AddFavoriteMovieUseCase(this._presenter, this.repository);

  @override
  execute(RequestData request) async {
    try{
      final data = (request as FavoriteRequest);
      final movie = data.movie;

      await repository.addToFavorites(movie);

      _presenter.execute(FavoriteResponse(
          success: true,
          message: "Movie added to favorites"));
    }catch(e){
      _presenter.execute(FavoriteResponse(
          success: false,
          message: e.toString()
      ));
    }
  }

}