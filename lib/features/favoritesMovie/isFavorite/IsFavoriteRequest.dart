import 'package:movie_app/constants/interfaces/RequestData.dart';

class IsFavoriteRequest extends RequestData{
  late final String _movieId;
  IsFavoriteRequest(this._movieId);

  String get movieId => _movieId;

  set movieId(String value) {
    _movieId = value;
  }
}