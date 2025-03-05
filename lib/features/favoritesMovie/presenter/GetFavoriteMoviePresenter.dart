
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/features/favoritesMovie/data/GetFavoriteResponse.dart';

import '../data/FavoriteResponse.dart';

class GetFavoriteMoviePresenter extends OutputBoundary{
  late List<Movies> listMovies;

  @override
  void execute(ResponseData response) {
    var data = (response as GetFavoriteResponse);
    listMovies = data.listMovies;
  }

  @override
  getData() {
    return listMovies;
  }

}