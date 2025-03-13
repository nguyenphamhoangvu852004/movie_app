import 'package:flutter/cupertino.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/features/authentication/register/RegisterResponseData.dart';

import '../../../model/User.dart';

class RegisterPresenter implements OutputBoundary{
  late User? user;

  @override
  void execute(ResponseData responseData) {
    if(responseData is RegisterResponseData){
      this.user = responseData.user;
    }
  }

  @override
  getData() {
    return this.user;
  }

}