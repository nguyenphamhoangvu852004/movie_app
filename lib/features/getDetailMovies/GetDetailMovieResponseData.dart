import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/DetailMovies.dart';

class GetDetailMovieResponseData implements ResponseData{
  DetailMovies _detailMovies;

  GetDetailMovieResponseData(this._detailMovies);

  DetailMovies get detailMovies => _detailMovies;

  set detailMovies(DetailMovies value) {
    _detailMovies = value;
  }
}