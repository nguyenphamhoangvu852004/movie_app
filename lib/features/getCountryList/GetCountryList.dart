import 'dart:convert';

import 'package:movie_app/constants/BaseUrl.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import "package:http/http.dart" as http;
import 'package:movie_app/data/Country.dart';
import 'package:movie_app/features/getCountryList/GetCountryListResponseData.dart';
import 'GetCountryListRequestData.dart';

class GetCountryList implements InputBoundary{
   OutputBoundary _presenter;

   GetCountryList(this._presenter);

  @override
  Future<void> execute(RequestData requestData) async {
    if (requestData is GetCountryListRequestData){
      try {
        var response =
            await http.get(Uri.parse("$APP_DOMAIN_API_DS_COUNTRY"));
        var decodedData = jsonDecode(response.body);
        List<Country> countryList = [];
        for (var item in decodedData) {
          Country category = Country(
            item["_id"].toString(),
            item["name"].toString(),
            item["slug"].toString(),
          );
          countryList.add(category);
        }

        GetCountryListResponseData getCountryListResponseData = GetCountryListResponseData(countryList);
        _presenter.execute(getCountryListResponseData);
      } catch (e) {
        GetCountryListResponseData getCountryListResponseData = GetCountryListResponseData([]);
        _presenter.execute(getCountryListResponseData);
        return;
      }
    }
  }

}