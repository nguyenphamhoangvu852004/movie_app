

import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';

class GetSeriesMoviesResponseData implements ResponseData {
  List<Movies> _list;


  GetSeriesMoviesResponseData(this._list);

  List<Movies> get list => _list;

  set list(List<Movies> value) {
    _list = value;
  }
}