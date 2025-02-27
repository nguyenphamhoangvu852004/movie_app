import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';

class GetMovieListResponseData implements ResponseData  {

  List<Movies> _list;

  GetMovieListResponseData(this._list);

  List<Movies> get list => _list;

  set list(List<Movies> value) {
    _list = value;
  }

  @override
  String toString() {
    return 'GetMovieListResponseData{_list: $_list}';
  }
}