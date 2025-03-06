import 'package:movie_app/constants/interfaces/ResponseData.dart';

class IsFavoriteResponse extends ResponseData{
  final bool _isExists;
  IsFavoriteResponse(this._isExists);

  bool get isExists => _isExists;
}