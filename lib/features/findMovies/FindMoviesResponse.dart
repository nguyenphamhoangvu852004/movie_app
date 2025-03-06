import 'package:movie_app/constants/interfaces/ResponseData.dart';

import '../../model/Movies.dart';

class FindMoviesResponse implements ResponseData{
  List<Movies> list;
  FindMoviesResponse(this.list);
}