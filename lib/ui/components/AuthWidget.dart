import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/features/authentication/login/LoginRequestData.dart';
import 'package:movie_app/features/authentication/register/RegisterRequestData.dart';

import '../screens/WidgetTree.dart';

class AuthWidget extends StatefulWidget {
  final InputBoundary registerUseCase;
  final OutputBoundary registerPresenter;
  final InputBoundary loginUseCase;
  final OutputBoundary loginPresenter;
  AuthWidget(this.registerUseCase, this.registerPresenter, this.loginUseCase,
      this.loginPresenter);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  bool isLogin = true;
  bool isLoading = false;
  String? errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool obscureText) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Không được để trống';
        if (label == 'Email' && !value.contains('@'))
          return 'Email không hợp lệ';
        if (label == 'Password' && value.length < 6)
          return 'Mật khẩu ít nhất 6 ký tự';
        if (label == 'Xác nhận mật khẩu' && value != _passwordController.text) {
          return 'Mật khẩu không khớp';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? 'Đăng nhập' : 'Đăng ký')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (!isLogin)
                _buildTextField(
                    'Username', _usernameController, false), // Thêm username
              _buildTextField('Email', _emailController, false),
              _buildTextField('Password', _passwordController, true),
              if (!isLogin)
                _buildTextField(
                    'Xác nhận mật khẩu', _confirmPasswordController, true),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _authenticate,
                      child: Text(isLogin ? 'Đăng nhập' : 'Đăng ký'),
                    ),
              TextButton(
                onPressed: () => setState(() {
                  isLogin = !isLogin;
                  ;
                  _emailController.clear();
                  _passwordController.clear();
                  _confirmPasswordController.clear();
                  _usernameController.clear();
                  errorMessage = null; // Xóa thông báo lỗi nếu có
                }),
                child: Text(isLogin
                    ? 'Chưa có tài khoản? Đăng ký'
                    : 'Đã có tài khoản? Đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (isLogin) {
      print("Đăng nhập với Email: $email");

      final req = LoginRequestData(email, password);
      await widget.loginUseCase.execute(req);
      final user = await widget.loginPresenter.getData();

      if (user == null) {
        setState(() {
          errorMessage = "Email hoặc mật khẩu không đúng.";
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Đăng nhập thành công!")));

        Future.delayed(Duration(seconds: 1), () {
          AuthRepoImp().loginSuccess(user); // Cập nhật trạng thái đăng nhập
        });
      }
    } else {
      final username = _usernameController.text.trim();
      print("Đăng ký với Username: $username, Email: $email");

      final req = RegisterRequestData(username, email, password);
      await widget.registerUseCase.execute(req);
      final user = await widget.registerPresenter.getData();

      if (user == null) {
        setState(() {
          errorMessage = "Đăng ký thất bại. Vui lòng thử lại.";
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Đăng ký thành công!")));

        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isLogin = true;
          });
        });
      }
    }
  }
}
