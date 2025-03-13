import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/features/authentication/register/Register.dart';
import 'package:movie_app/ui/components/AuthWidget.dart';
import 'package:movie_app/ui/components/UserScreen.dart';

import '../../model/User.dart';

class WidgetTree extends StatefulWidget {
  final InputBoundary register;
  final OutputBoundary registerPresenter;
  final InputBoundary login;
  final OutputBoundary loginPresenter;

  WidgetTree(this.register, this.registerPresenter, this.login, this.loginPresenter);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}

class _WidgetTreeState extends State<WidgetTree> {
  String? username;
  String? email;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: AuthRepoImp().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // Khi user đăng nhập thành công -> Lấy thông tin user
          final user = snapshot.data;
          return UserScreen(
            username: user!.username,
            email: user.email,
            onLogout: _logout,
          );
        } else {
          return AuthWidget(widget.register, widget.registerPresenter, widget.login, widget.loginPresenter);
        }
      },
    );
  }

  void _logout() {
    AuthRepoImp().signOut();
    setState(() {});
  }
}



class AuthRepoImp {
  static final AuthRepoImp _instance = AuthRepoImp._internal();
  factory AuthRepoImp() => _instance;

  final _authController = StreamController<User?>.broadcast();
  User? _currentUser;

  AuthRepoImp._internal();

  Stream<User?> get authStateChanges => _authController.stream;

  void loginSuccess(User user) {
    _currentUser = user;
    _authController.add(_currentUser);
  }

  void signOut() {
    _currentUser = null;
    _authController.add(null);
  }
  User? getCurrentUser(){
    return this._currentUser;
  }
}
