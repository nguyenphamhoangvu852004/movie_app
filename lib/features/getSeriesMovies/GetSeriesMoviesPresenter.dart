


import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/features/getSeriesMovies/GetSeriesMoviesResponseData.dart';

class GetSeriesMoviesPresenter implements OutputBoundary {
  List<Movies> _movies = [];


  @override
  void execute(ResponseData responseData) {
    if (responseData is GetSeriesMoviesResponseData) {
      _movies = responseData.list;
    }
  }

  @override
  List<Movies> getData() {
    return _movies;
  }

}