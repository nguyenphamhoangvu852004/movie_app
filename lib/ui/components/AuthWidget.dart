

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/features/authentication/AuthRepo/AuthRepoImp.dart';

import 'package:flutter/material.dart';

import '../../data/AuthResult.dart';
import '../../features/authentication/AuthRepo/AuthRepo.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({super.key});

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  String? errorMessage;
  final AuthRepo _authRepo = AuthRepoImp();

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    AuthResult result;
    if (isLogin) {
      result = await _authRepo.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    } else {
      result = await _authRepo.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
    }

    setState(() {
      isLoading = false;
      if (result.isSuccess) {
        print("Thành công: UID = ${result.uid}");
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        errorMessage = result.error ?? "Thất bại không rõ nguyên nhân";
        print("Lỗi: $errorMessage");
      }
    });
  }

  Future<void> _loginWithGoogle() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await _authRepo.loginWithGoogle();
    setState(() {
      isLoading = false;
      if (result!.isSuccess) {
        print("Đăng nhập Google thành công: UID = ${result.uid}");
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        errorMessage = result.error ?? "Đăng nhập Google thất bại";
        print("Lỗi Google: $errorMessage");
      }
    });
  }

  Widget _buildTextField(String label, TextEditingController controller, bool obscureText) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Không được để trống';
        if (label == 'Email' && !value.contains('@')) return 'Email không hợp lệ';
        if (label == 'Password' && value.length < 6) return 'Mật khẩu ít nhất 6 ký tự';
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
              _buildTextField('Email', _emailController, false),
              _buildTextField('Password', _passwordController, true),
              if (!isLogin) _buildTextField('Xác nhận mật khẩu', _confirmPasswordController, true),
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
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin ? 'Chưa có tài khoản? Đăng ký' : 'Đã có tài khoản? Đăng nhập'),
              ),
              TextButton(
                onPressed: _loginWithGoogle,
                child: const Text('Đăng nhập bằng Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
