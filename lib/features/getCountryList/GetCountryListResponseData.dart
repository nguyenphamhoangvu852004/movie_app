import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/model/Country.dart';

import '../../model/Category.dart';

class GetCountryListResponseData implements ResponseData{
  List<Country> _countryList;

  GetCountryListResponseData(this._countryList);

  List<Country> get countryList => _countryList;

  set countryList(List<Country> value) {
    _countryList = value;
  }
}