import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/model/Movies.dart';

import 'FindMovieListResponseData.dart';

class FindMovieListPresenter implements OutputBoundary{

  late List<Movies> list;

  @override
  void execute(ResponseData responseData) {
    if (responseData is FindMovieListResponseData) {
      list = responseData.listData;
    }
  }

  @override
  getData() {
    return list;
  }

}