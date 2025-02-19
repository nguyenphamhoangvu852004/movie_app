
import 'package:movie_app/constants/interfaces/RequestData.dart';

class GetSeriesMoviesRequestData implements RequestData {
  int _page;

  GetSeriesMoviesRequestData(this._page);

  int get page => _page;

  set page(int value) {
    _page = value;
  }
}