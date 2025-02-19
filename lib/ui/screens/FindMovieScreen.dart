import 'package:flutter/material.dart';

class FindMovieScreen extends StatefulWidget {
  final Widget findMovieWidget;


  const FindMovieScreen(this.findMovieWidget, {super.key});

  @override
  State<FindMovieScreen> createState() => _FindMovieScreenState();
}

class _FindMovieScreenState extends State<FindMovieScreen> {
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
          widget.findMovieWidget
        ],
      ),
    );
  }
}
