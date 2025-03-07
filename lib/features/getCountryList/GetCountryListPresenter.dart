import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/model/Category.dart';
import 'package:movie_app/model/Country.dart';

import '../../constants/interfaces/ResponseData.dart';
import 'GetCountryListResponseData.dart';

class GetCountryListPresenter implements OutputBoundary{
  List<Country> data = [];
  @override
  void execute(ResponseData responseData) {
    if (responseData is GetCountryListResponseData) {
      data = responseData.countryList;
    }
  }

  @override
  getData() {
    return data;
  }
}