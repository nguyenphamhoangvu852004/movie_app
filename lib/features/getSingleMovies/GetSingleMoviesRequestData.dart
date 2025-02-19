
import 'package:movie_app/constants/interfaces/RequestData.dart';

class GetSingleMoviesRequestData implements RequestData{
   int _page;

   GetSingleMoviesRequestData(this._page);

   int get page => _page;

  set page(int value) {
    _page = value;
  }
}