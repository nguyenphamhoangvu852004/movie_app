import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/data/Category.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/features/getSingleMovies/GetSingleMoviesRequestData.dart';
import 'package:movie_app/features/getSingleMovies/GetSingleMoviesResponseData.dart';
import '../../constants/BaseUrl.dart';
import '../../data/Country.dart';

class GetSingleMovies implements InputBoundary {
  final OutputBoundary presenter;
  GetSingleMovies(this.presenter);
  @override
  Future<void> execute(RequestData requestData) async {
    List<Movies> fetchedMovies = [];
    var page;
    if (requestData is GetSingleMoviesRequestData) {
      page = requestData.page;
    }
    try {
      // Fetch danh sách phim lẻ
      var response = await http.get(Uri.parse("$APP_DOMAIN_API_DS_PHIM_LE?page=$page"));
      var decodedData = jsonDecode(response.body);
      var data = decodedData["data"];
      var items = data["items"];
      print(decodedData);
      for (var item in items) {
        List<Category> categoryList = [];
        for (var category in item["category"]) {
          categoryList.add(Category(
            category["_id"].toString(),
            category["name"].toString(),
            category["slug"].toString(),
          ));
        }
        List<Country> countryList = [];
        for (var country in item["country"]) {
          countryList.add(Country(
            country["_id"].toString(),
            country["name"].toString(),
            country["slug"].toString(),
          ));
        }
        Movies movie = Movies(
            item["_id"].toString(),
            item["name"].toString(),
            item["slug"].toString(),
            item["origin_name"].toString(),
            item["type"].toString(),
            item["poster_url"].toString(),
            item["thumb_url"].toString(),
            item["sub_docquyen"],
            item["chieurap"],
            item["time"].toString(),
            item["episode_current"].toString(),
            item["quality"].toString(),
            item["lang"].toString(),
            item["year"],
            categoryList,
            countryList
        );
        fetchedMovies.add(movie);
      }
      var responseData = GetSingleMoviesResponseData(fetchedMovies);
      presenter.execute(responseData);
    } catch (e) {
      print("Error: $e");
      var responseData = GetSingleMoviesResponseData([]);
      presenter.execute(responseData);
      return;
    }
  }
}
