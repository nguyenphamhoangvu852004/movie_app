import 'package:movie_app/constants/interfaces/RequestData.dart';

class GetMovieListRequestData implements RequestData {
  String _domainStr;
  int _page;

  GetMovieListRequestData(this._domainStr, this._page);

  int get page => _page;

  set page(int value) {
    _page = value;
  }

  String get domainStr => _domainStr;

  set domainStr(String value) {
    _domainStr = value;
  }
}
