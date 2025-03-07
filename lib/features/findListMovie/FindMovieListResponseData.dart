import '../../constants/interfaces/ResponseData.dart';
import '../../model/Movies.dart';

class FindMovieListResponseData implements ResponseData {
  List<Movies> listData;

  FindMovieListResponseData(this.listData);


}