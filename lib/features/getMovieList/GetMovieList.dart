import 'dart:convert';

import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/model/Category.dart';
import 'package:movie_app/model/Country.dart';
import 'package:movie_app/features/getMovieList/GetMovieListRequestData.dart';

import '../../model/Movies.dart';
import 'package:http/http.dart' as http;

import 'GetMovieListResponseData.dart';

class GetMovieList implements InputBoundary {
  final OutputBoundary _presenter;

  GetMovieList(this._presenter);

  @override
  Future<void> execute(RequestData requestData) async {
    if (requestData is GetMovieListRequestData) {
      List<Movies> listData = [];
      String appDomain = requestData.domainStr;
      int page = requestData.page;
      int limit = requestData.limit;
      String url = "$appDomain?page=$page&limit=$limit";

      try {
        var response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          var decodedData = jsonDecode(response.body);
          var data = decodedData["data"]["items"]; // Lấy items từ data
          if (data is List) {
            for (var item in data) {
              List<Category> categoryList = [];
              List<Country> countryList = [];

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
          var responseData = GetMovieListResponseData(listData);
          _presenter.execute(responseData);
        } else {
          throw Exception("API failed with status: ${response.statusCode}");
        }
      } catch (e) {
        print("Error: $e");
        var responseData = GetMovieListResponseData([]);
        _presenter.execute(responseData);
      }
    }
  }
  String getPosterUrl(String url) {
    if (url.startsWith('http')) {
      return url;
    }
    return "https://phimimg.com/$url";
  }
}
