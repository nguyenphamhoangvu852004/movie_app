import 'dart:convert';

import 'package:movie_app/constants/DomainUrl.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/model/Category.dart';
import 'package:movie_app/features/getTypeList/GetTypeListResponseData.dart';
import 'package:http/http.dart' as http;
class GetTypeList implements InputBoundary {
  final OutputBoundary _presenter;

  GetTypeList(this._presenter);

  @override
  execute(RequestData requestData) async {
    try {
      var response =
          await http.get(Uri.parse(APP_DOMAIN_API_DS_PHIM_LE));
      var decodedData = jsonDecode(response.body);
      List<Category> categories = [];
      for (var item in decodedData) {
        Category category = Category(
          item["_id"].toString(),
          item["name"].toString(),
          item["slug"].toString(),
        );
        categories.add(category);
      }

      GetTypeListResponseData resData = GetTypeListResponseData(categories);
      _presenter.execute(resData);
    } catch (e) {
      GetTypeListResponseData resData = GetTypeListResponseData([]);
      _presenter.execute(resData);
      return;
    }
  }
}
