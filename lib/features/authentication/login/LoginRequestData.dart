import 'package:movie_app/constants/interfaces/RequestData.dart';

class LoginRequestData implements RequestData{
  final String email;
  final String password;

  LoginRequestData(this.email, this.password);
}