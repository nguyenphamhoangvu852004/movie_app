
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';

import 'IsFavoriteResponse.dart';

class IsFavoriteMoviePresenter extends OutputBoundary{
  var isExists;

  @override
  void execute(ResponseData response) {
    var data = (response as IsFavoriteResponse);
    isExists = data.isExists;
  }

  @override
  getData() {
    return isExists;
  }

}