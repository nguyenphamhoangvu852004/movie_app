import 'dart:convert';

import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/features/findListMovie/FindMovieListRequestData.dart';
import 'package:movie_app/features/findListMovie/FindMovieListResponseData.dart';
import 'package:movie_app/model/Category.dart';

import '../../constants/interfaces/RequestData.dart';
import '../../model/Country.dart';
import '../../model/Movies.dart';
import 'package:http/http.dart' as http;

class FindMovieList implements InputBoundary{
  final OutputBoundary _presenter;

  FindMovieList(this._presenter);

  @override
  Future<void> execute(RequestData requestData) async {
    if (requestData is FindMovieListRequestData) {
      List<Movies> listData = [];
      String appDomain = requestData.domainStr;
      String keyword = requestData.keyword;
      if(keyword.isEmpty || keyword ==""){
        keyword = "?";
      }
      String type = requestData.type;
      String country = requestData.country;
      String url =  buildUrl(appDomain, keyword, type, country);
      print(url.toString());
      try {
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          var data = decodedData["data"]["items"]; // Lấy items từ data
          if (data is List) {
            for (var item in data) {
              List<Category> categoryList = [];
              List<Country> countryList = [];

              // Debug dữ liệu
              // print("item['category']: ${item["category"]}");
              // print("item['country']: ${item["country"]}");

              // Xử lý category
              if (item["category"] != null && item["category"] is Iterable) {
                for (var category in item["category"]) {
                  categoryList.add(Category(
                    category["id"]?.toString() ?? "",
                    category["name"]?.toString() ?? "",
                    category["slug"]?.toString() ?? "",
                  ));
                }
              } else {
                print("Warning: category is not iterable: ${item["category"]}");
              }

              // Xử lý country
              if (item["country"] != null && item["country"] is Iterable) {
                for (var country in item["country"]) {
                  countryList.add(Country(
                    country["id"]?.toString() ?? "",
                    country["name"]?.toString() ?? "",
                    country["slug"]?.toString() ?? "",
                  ));
                }
              } else {
                print("Warning: country is not iterable: ${item["country"]}");
              }

              Movies movie = Movies(
                item["_id"]?.toString() ?? "",
                item["name"]?.toString() ?? "",
                item["slug"]?.toString() ?? "",
                item["origin_name"]?.toString() ?? "",
                item["type"]?.toString() ?? "null",
                getPosterUrl(item["poster_url"]?.toString() ?? ""),
                getPosterUrl(item["thumb_url"]?.toString() ?? ""),
                item["sub_docquyen"] ?? false,
                item["chieurap"] ?? false,
                item["time"]?.toString() ?? "null",
                item["episode_current"]?.toString() ?? "null",
                item["quality"]?.toString() ?? "null",
                item["lang"]?.toString() ?? "null",
                item["year"] ?? 0,
                categoryList,
                countryList,
              );
              listData.add(movie);
              print("Fetched movie: ${movie.posterUrl}");
            }
          } else {
            print("Error: 'items' is not a List: $data");
          }
          var responseData = FindMovieListResponseData(listData);
          _presenter.execute(responseData);
        } else {
          throw Exception("API failed with status: ${response.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
        var responseData = FindMovieListResponseData([]);
        _presenter.execute(responseData);
      }
    }
  }
  String getPosterUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    }
    return "https://phimimg.com/$url"; // Dùng APP_DOMAIN_CDN_IMAGE từ API
  }

  String buildUrl(String domain, String keyword, String type, String country) {
    Map<String, String> queryParams = {};

    if (keyword.isNotEmpty) {
      queryParams["keyword"] = keyword;
    }
    if (type.isNotEmpty) {
      queryParams["category"] = type;
    }
    if (country.isNotEmpty) {
      queryParams["country"] = country;
    }

    Uri uri = Uri.parse(domain).replace(queryParameters: queryParams);
    return uri.toString();
  }
}