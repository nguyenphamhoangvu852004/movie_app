import 'package:flutter/material.dart';


class DetailMovieScreen extends StatefulWidget {
  final Widget detailMovieWidget;
  const DetailMovieScreen(this.detailMovieWidget,{super.key});

  @override
  State<DetailMovieScreen> createState() => _DetailMovieScreenState();
}

class _DetailMovieScreenState extends State<DetailMovieScreen> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // widget.detailMovieWidget,
          Text("Đây là trang chi tiết phim")
        ],
    ));
  }
}
