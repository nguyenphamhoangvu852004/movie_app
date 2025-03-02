
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/model/Movies.dart';
import 'package:movie_app/features/getNewMovies/GetNewMoviesResponseData.dart';

class GetNewMoviesPresenter implements OutputBoundary{
   List<Movies> _movies = [];

  @override
  void execute(ResponseData responseData) {
    if (responseData is GetNewMoviesResponseData) {
      _movies = responseData.list;
    }
  }

  @override
  getData() {
    return _movies;
  }

}