import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';
class GetSingleMoviesResponseData implements ResponseData {

  List<Movies> _list;

  GetSingleMoviesResponseData(this._list);

  List<Movies> get list => _list;

  set list(List<Movies> value) {
    _list = value;
  }

}