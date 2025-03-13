import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/features/authentication/register/RegisterRequestData.dart';
import 'package:movie_app/features/authentication/register/RegisterResponseData.dart';

import '../../../constants/interfaces/OutputBoundary.dart';
import '../../../data/repository/MovieRepository.dart';
import '../../../model/User.dart';

class Register implements InputBoundary {
  final OutputBoundary _presenter;
  final MovieRepository repository;

  Register(this._presenter, this.repository);

  @override
  execute(RequestData requestData) async {
    final req = requestData as RegisterRequestData;
    final username = req.username;
    final email = req.email;
    final pass = req.password;

    // Kiểm tra email đã tồn tại hay chưa
    User? existingUser = await repository.getUserByEmail(email);
    if (existingUser != null) {
      _presenter.execute(RegisterResponseData(null));
      return;
    }

    // Tạo user mới
    User newUser = User(username: username, email: email, password: pass);
    User? createdUser = await repository.createUser(newUser);
    print(createdUser);
    // Trả kết quả
    _presenter.execute(RegisterResponseData(createdUser));
  }
}
