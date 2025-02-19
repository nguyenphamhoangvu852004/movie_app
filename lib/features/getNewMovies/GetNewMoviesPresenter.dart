
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/features/getNewMovies/GetNewMoviesResponseData.dart';

class GetNewMoviesPresenter implements OutputBoundary{
  List<Movies> _movies;

  GetNewMoviesPresenter(this._movies);

  @override
  void execute(ResponseData responseData) {
    if (responseData is GetNewMoviesResponseData) {
      for (var movie in responseData.list) {
        _movies.add(movie);
      }
    }
  }

  @override
  getData() {
    return _movies;
  }

}