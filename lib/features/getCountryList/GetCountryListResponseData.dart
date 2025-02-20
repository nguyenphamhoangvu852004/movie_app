import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Country.dart';

class GetCountryListResponseData implements ResponseData {
  List<Country> _list;

  GetCountryListResponseData(this._list);

  List<Country> get list => _list;

  set list(List<Country> value) {
    _list = value;
  }
}
