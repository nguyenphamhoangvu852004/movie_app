import 'package:movie_app/constants/interfaces/RequestData.dart';

class GetMovieListRequestData implements RequestData {
  String _domainStr;
  int _page;
  int _limit;

  GetMovieListRequestData(this._domainStr, this._page,this._limit);

  int get page => _page;

  set page(int value) {
    _page = value;
  }

  String get domainStr => _domainStr;

  set domainStr(String value) {
    _domainStr = value;
  }

  int get limit => _limit;

  set limit(int value) {
    _limit = value;
  }
}
