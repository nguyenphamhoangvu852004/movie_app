

import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';

class GetNewMoviesResponseData implements ResponseData{
  List<Movies> _list;

  GetNewMoviesResponseData(this._list);

  List<Movies> get list => _list;

  set list(List<Movies> value) {
    _list = value;
  }

  @override
  String toString() {
    return 'GetNewMoviesResponseData{_list: $_list}';
  }
}