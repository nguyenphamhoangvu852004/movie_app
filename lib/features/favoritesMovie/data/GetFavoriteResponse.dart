import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';

class GetFavoriteResponse extends ResponseData{
  List<Movies> _list;
  GetFavoriteResponse(this._list);

  List<Movies> get listMovies => _list;
}