import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Movies.dart';

class FindMoviesResponse implements ResponseData{
  List<Movies> list;
  FindMoviesResponse(this.list);
}