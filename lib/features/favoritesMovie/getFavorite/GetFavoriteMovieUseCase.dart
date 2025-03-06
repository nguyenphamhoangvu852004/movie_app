
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/data/repository/MovieRepository.dart';
import 'package:movie_app/features/favoritesMovie/getFavorite/GetFavoriteResponse.dart';

import '../../../model/Movies.dart';
import '../addFavorite/FavoriteRequest.dart';
import '../addFavorite/FavoriteResponse.dart';

class GetFavoriteMovieUseCase implements InputBoundary{

  final OutputBoundary _presenter;
  final MovieRepository repository;
  GetFavoriteMovieUseCase(this._presenter, this.repository);

  @override
  execute(RequestData request) async {
    try{
      List<Movies> movies = await repository.getFavoriteMovies();
      _presenter.execute(GetFavoriteResponse(movies));
    }catch(e){
      print(e);
    }
  }

}