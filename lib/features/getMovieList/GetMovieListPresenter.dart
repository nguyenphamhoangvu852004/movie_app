import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/model/Movies.dart';
import 'package:movie_app/features/getMovieList/GetMovieListResponseData.dart';

class GetMovieListPresenter implements OutputBoundary {
  late List<Movies> list;

  @override
  void execute(ResponseData responseData) {
    if (responseData is GetMovieListResponseData) {
      list = responseData.list; // Cập nhật danh sách mới
    }
  }

  @override
  List<Movies> getData() => list;
}
