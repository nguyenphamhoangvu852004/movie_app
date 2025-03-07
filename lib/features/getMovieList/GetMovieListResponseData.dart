import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/model/Movies.dart';

class GetMovieListResponseData implements ResponseData  {

  List<Movies> list;

  GetMovieListResponseData(this.list);

  @override
  String toString() {
    return 'GetMovieListResponseData{_list: $list}';
  }
}