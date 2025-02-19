
import 'package:movie_app/constants/interfaces/RequestData.dart';

class GetTypeListRequestData implements RequestData{
  int _page;

  GetTypeListRequestData(this._page);

  int get page => _page;

  set page(int value) {
    _page = value;
  }
}