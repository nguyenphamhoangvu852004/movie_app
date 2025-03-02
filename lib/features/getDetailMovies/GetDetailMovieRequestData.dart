

import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/model/Movies.dart';

class GetDetailMovieRequestData  implements RequestData {

  Movies _movies;

  GetDetailMovieRequestData(this._movies);

  Movies get movies => _movies;

  set movies(Movies value) {
    _movies = value;
  }

  @override
  String toString() {
    return 'GetDetailMovieRequestData{_movies: $_movies}';
  }

}