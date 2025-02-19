


import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/features/getSingleMovies/GetSingleMoviesResponseData.dart';

class GetSingleMoviesPresenter implements OutputBoundary {
  List<Movies> _movies;

  GetSingleMoviesPresenter(this._movies);

  @override
  void execute(ResponseData responseData) {
    if (responseData is GetSingleMoviesResponseData) {
      _movies = responseData.list;
    }
  }

  @override
  List<Movies> getData() {
    return _movies;
  }
}