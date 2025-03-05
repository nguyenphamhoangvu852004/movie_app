import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/data/Movies.dart';

class FavoriteRequest extends RequestData{
  final Movies _movie;
  FavoriteRequest(this._movie);

  Movies get movie => _movie;

}