
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';

import '../data/FavoriteResponse.dart';

class FavoriteMoviePresenter extends OutputBoundary{
  var message;

  @override
  void execute(ResponseData response) {
    var data = (response as FavoriteResponse);
    message = data.message;
  }

  @override
  getData() {
    return message;
  }

}