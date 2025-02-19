import 'package:flutter/material.dart';
class HomeScreen extends StatefulWidget {

  final Widget singleMoviesWidget;
  final Widget seriesMoviesWidget;
  final Widget newMoviesWidget;
  const HomeScreen(this.singleMoviesWidget,this.seriesMoviesWidget,this.newMoviesWidget,{super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black,
            Colors.pinkAccent,
          ],
        ),
      ),
      child: ListView(
        children: [
          widget.newMoviesWidget,
          widget.singleMoviesWidget,
          widget.seriesMoviesWidget,
        ],
      ),
    );
  }
}
