import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/model/User.dart';

class RegisterResponseData implements ResponseData{
  User? user;
  RegisterResponseData(this.user);
}
