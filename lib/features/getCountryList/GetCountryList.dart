import 'dart:convert';

import 'package:movie_app/constants/DomainUrl.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/features/getCountryList/GetCountryListResponseData.dart';
import 'package:movie_app/features/getTypeList/GetTypeListResponseData.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/model/Country.dart';
class GetCountryList implements InputBoundary {
  final OutputBoundary _presenter;

  GetCountryList(this._presenter);

  @override
  execute(RequestData requestData) async {
    try {
      var response =
          await http.get(Uri.parse(APP_DOMAIN_API_DS_COUNTRYS));
      var decodedData = jsonDecode(response.body);
      List<Country> countries = [];
      for (var item in decodedData) {
        Country country = Country(
          item["_id"].toString(),
          item["name"].toString(),
          item["slug"].toString(),
        );
        countries.add(country);
      }

      GetCountryListResponseData resData = GetCountryListResponseData(countries);
      _presenter.execute(resData);
    } catch (e) {
      GetCountryListResponseData resData = GetCountryListResponseData([]);
      _presenter.execute(resData);
      return;
    }
  }
}
