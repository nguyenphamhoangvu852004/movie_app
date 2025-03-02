import 'dart:convert';

import 'package:movie_app/constants/DomainUrl.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/model/Category.dart';
import 'package:movie_app/model/Country.dart';
import 'package:movie_app/model/Movies.dart';
import 'package:movie_app/features/getNewMovies/GetNewMoviesRequestData.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app/features/getNewMovies/GetNewMoviesResponseData.dart';

class GetNewMovies implements InputBoundary{
  final OutputBoundary _presenter;
  GetNewMovies(this._presenter);
  @override
  execute(RequestData requestData) async {
    List<Movies> listData = [];
    String? page;
    if (requestData is GetNewMoviesRequestData){
      page = requestData.page;
    }
    try{
      var response = await http.get(Uri.parse("$APP_DOMAIN_API_DS_PHIM_MOI?page=$page"));
      var decodedData = jsonDecode(response.body);
      var data = decodedData["items"];
      for (var item in data) {
        List<Category> categoryList = [];
        List<Country> countryList = [];
        // Kiểm tra null trước khi parse category
        if (item["category"] != null) {
          for (var category in item["category"]) {
            categoryList.add(Category(
              category["_id"]?.toString() ?? "",
              category["name"]?.toString() ?? "",
              category["slug"]?.toString() ?? "",
            ));
          }
        }
        // Kiểm tra null trước khi parse country
        if (item["country"] != null) {
          for (var country in item["country"]) {
            countryList.add(Country(
              country["_id"]?.toString() ?? "",
              country["name"]?.toString() ?? "",
              country["slug"]?.toString() ?? "",
            ));
          }
        }
        Movies movie = Movies(
          item["_id"].toString(),
          item["name"].toString(),
          item["slug"].toString(),
          item["origin_name"].toString(),
          item["type"].toString()??"null",
          getPosterUrl(item["poster_url"].toString()),
          getPosterUrl(item["thumb_url"].toString()),
          item["sub_docquyen"]??false,
          item["chieurap"]??false,
          item["time"].toString()??"null",
          item["episode_current"].toString()??"null",
          item["quality"].toString()??"null",
          item["lang"].toString()??"null",
          item["year"]??0,
          categoryList?? [],
          countryList?? [],
        );
        listData.add(movie);
        print(movie.posterUrl);
      }
      var responseData = GetNewMoviesResponseData(listData);
      _presenter.execute(responseData);
      return;
    }catch(e){
      print(e);
      var responseData = GetNewMoviesResponseData([]);
      _presenter.execute(responseData);
      return;
    }
  }

  String getPosterUrl(String url) {
    // Kiểm tra nếu URL chứa "phimimg.com/"
    int index = url.indexOf('phimimg.com/');
    if (index != -1) {
      // Lấy phần sau "phimimg.com/"
      return url.substring(index + 'phimimg.com/'.length);
    }
    return url; // Trả về URL gốc nếu không tìm thấy "phimimg.com/"
  }
}
