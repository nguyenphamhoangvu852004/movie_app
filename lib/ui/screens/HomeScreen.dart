import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {
  final Widget singleMoviesWidget;
  final Widget seriesMoviesWidget;
  final Widget newMoviesWidget;

  const HomeScreen(
      this.singleMoviesWidget, this.seriesMoviesWidget, this.newMoviesWidget,
      {super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF000000), // Màu đen deep
              Color(0xFF4E342E), // Màu nâu trầm ấm
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20),
          children: [
              widget.newMoviesWidget,
              widget.singleMoviesWidget,
              widget.seriesMoviesWidget,
          ],
        ),
      ),
    );
  }
}
