
import 'package:movie_app/constants/BaseUrl.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/data/DetailMovies.dart';
import 'package:movie_app/data/Episode.dart';

import 'package:http/http.dart' as http;
import 'package:movie_app/data/ServerData.dart';
import 'dart:convert';

import 'package:movie_app/features/getDetailMovies/GetDetailMovieRequestData.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMovieResponseData.dart';
class GetDetailMovie extends InputBoundary {
  final OutputBoundary _presenter;
  GetDetailMovie(this._presenter);

  @override
  Future<void> execute(RequestData requestData) async {
    try {
      final movieData = (requestData as GetDetailMovieRequestData);
      final currentMovie = movieData.movies;

      final response = await http.get(Uri.parse("$APP_DOMAIN_API_DETAIL_MOVIE/${currentMovie.slug.toString()}"));
      final decodedData = jsonDecode(response.body);
      final decodeEpisodes = decodedData["episodes"];
      final movie = decodedData["movie"];
      List<Episode> episodes = [];

      for (var episodeItem in decodeEpisodes) {
        String serverName = episodeItem["server_name"] ?? "";
        List<ServerData> serverDataList = [];

        if (episodeItem["server_data"] is List) {
          for (var serverItem in episodeItem["server_data"]) {
            serverDataList.add(ServerData(
               serverItem["name"] ?? "",
               serverItem["slug"] ?? "",
               serverItem["filename"] ?? "",
               serverItem["link_embed"] ?? "",
               serverItem["link_m3u8"] ?? "",
            ));
          }
        }

        episodes.add(Episode(
           serverName,
          serverDataList,
        ));
      }
      // // Parse episodes một lần duy nhất
      // final episodes = _parseEpisodes(decodedData["episodes"] as List);

      final detailMovie = DetailMovies(
          currentMovie,
          movie["content"].toString(),
          movie["status"].toString(),
          movie["is_copyright"] ?? false,
          movie["trailer_url"].toString(),
          movie["episode_total"].toString(),
          movie["notify"].toString(),
          movie["showtimes"].toString(),
          movie["view"] ?? 0,
          episodes
      );

      _presenter.execute(GetDetailMovieResponseData(detailMovie));
    } catch (e) {
      print("Error in GetDetailMovie: $e");
      // Trả về response rỗng khi có lỗi
      _presenter.execute(GetDetailMovieResponseData(null as DetailMovies));
    }
  }
}
