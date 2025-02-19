

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/features/authentication/Auth.dart';

class LoginWidget extends StatefulWidget {
  const LoginWidget({super.key});

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool isLogin = true;
  bool isLoading = false;
  String? errorMessage;

  Future<void> _authenticate() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => isLoading = true);

    try {
      if (isLogin) {
        await Auth().signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      } else {
        await Auth().createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => errorMessage = e.message);
    } finally {
      setState(() => isLoading = false);
    }
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
                Text(errorMessage!, style: TextStyle(color: Colors.red)),
              const SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                onPressed: _authenticate,
                child: Text(isLogin ? 'Đăng nhập' : 'Đăng ký'),
              ),
              TextButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                child: Text(isLogin ? 'Chưa có tài khoản? Đăng ký' : 'Đã có tài khoản? Đăng nhập'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
