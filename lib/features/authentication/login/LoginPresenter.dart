import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/features/authentication/login/LoginResponseData.dart';

import '../../../model/User.dart';

class LoginPresenter implements OutputBoundary{
  late User? user;
  @override
  void execute(ResponseData responseData) {
    if (responseData is LoginResponseData){
      this.user = responseData.user;
    }
  }

  @override
  User? getData() {
    return user;
  }

}