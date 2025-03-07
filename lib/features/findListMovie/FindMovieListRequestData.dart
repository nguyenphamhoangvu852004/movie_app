import '../../constants/interfaces/RequestData.dart';

class FindMovieListRequestData implements RequestData {
  String domainStr;
  String keyword;
  String type;
  String country;

  FindMovieListRequestData(this.domainStr,this.keyword, this.type, this.country);
}