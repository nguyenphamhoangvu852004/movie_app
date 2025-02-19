
import 'package:movie_app/constants/interfaces/RequestData.dart';

class GetNewMoviesRequestData implements RequestData{
  String _page;

  GetNewMoviesRequestData(this._page);

  String get page => _page;

  set page(String value) {
    _page = value;
  }
}