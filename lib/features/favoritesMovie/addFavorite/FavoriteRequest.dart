import 'package:movie_app/constants/interfaces/RequestData.dart';

import '../../../model/Movies.dart';

class FavoriteRequest extends RequestData{
  final int? userId;
  final Movies _movie;
  FavoriteRequest(this.userId,this._movie);

  Movies get movie => _movie;

}