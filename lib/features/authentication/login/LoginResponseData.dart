import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/model/User.dart';

class LoginResponseData implements ResponseData{
  User user;
  LoginResponseData(this.user);
}
