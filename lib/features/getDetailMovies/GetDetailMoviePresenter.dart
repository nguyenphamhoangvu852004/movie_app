

import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/DetailMovies.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMovieResponseData.dart';

class GetDetailMoviePresenter extends OutputBoundary {
  late DetailMovies detailMovies;
  @override
  void execute(ResponseData responseData) {
    if (responseData is GetDetailMovieResponseData) {
      detailMovies = responseData.detailMovies;
    }
  }

  @override
  getData() {
    return detailMovies;
  }
}
