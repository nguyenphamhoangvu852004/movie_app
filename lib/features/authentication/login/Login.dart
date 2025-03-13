
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/features/authentication/login/LoginRequestData.dart';
import 'package:movie_app/features/authentication/login/LoginResponseData.dart';

import '../../../constants/interfaces/OutputBoundary.dart';
import '../../../data/repository/MovieRepository.dart';
import '../../../model/User.dart';

class Login implements InputBoundary{
  final OutputBoundary _presenter;
  final MovieRepository repository;

  Login(this._presenter, this.repository);

  @override
  execute(RequestData requestData) async {
    final req = requestData as LoginRequestData;
    final email = req.email;
    final pass = req.password;
    User? userFindFromDB = await this.repository.getUserByEmail(email);
    if(userFindFromDB != null){
      // so sanh pass
      if(pass != userFindFromDB.password){
        final res = new LoginResponseData(userFindFromDB);
        this._presenter.execute(res);
        return;
      }

      final res = new LoginResponseData(userFindFromDB);
      this._presenter.execute(res);
      return;
    }
  }

}