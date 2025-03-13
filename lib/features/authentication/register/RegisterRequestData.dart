import 'package:movie_app/constants/interfaces/RequestData.dart';

class RegisterRequestData implements RequestData{
  final String username;
  final String email;
  final String password;

  RegisterRequestData(this.username, this.email, this.password);
}