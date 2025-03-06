import 'package:movie_app/constants/interfaces/RequestData.dart';

class FindMoviesRequest implements RequestData{
  String name;
  FindMoviesRequest(this.name);
}