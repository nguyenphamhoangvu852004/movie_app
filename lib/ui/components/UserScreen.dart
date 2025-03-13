import 'package:flutter/material.dart';


class UserScreen extends StatefulWidget {
  final String username;
  final String email;
  final VoidCallback onLogout;

  const UserScreen({
    super.key,
    required this.username,
    required this.email,
    required this.onLogout,
  });

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Screen"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: widget.onLogout, // Gọi hàm logout
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Xin chào, ${widget.username}!",
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text("Email: ${widget.email}",
                style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: widget.onLogout, // Nút logout
              child: const Text("Đăng xuất"),
            ),
          ],
        ),
      ),
    );
  }
}
