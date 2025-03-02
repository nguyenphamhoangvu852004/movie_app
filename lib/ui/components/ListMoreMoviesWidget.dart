import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';

import '../../constants/interfaces/OutputBoundary.dart';

class ListMoreMoviesWidget extends StatefulWidget {

  final InputBoundary getMoviesUseCase;
  final OutputBoundary getMoviesPresenter;
  final InputBoundary getDetailMoviesUseCase;
  final OutputBoundary getDetailMoviesPresenter;

  ListMoreMoviesWidget(this.getMoviesUseCase, this.getMoviesPresenter,
      this.getDetailMoviesUseCase, this.getDetailMoviesPresenter);

  @override
  State<ListMoreMoviesWidget> createState() => _ListMoreMoviesWidgetState();
}

class _ListMoreMoviesWidgetState extends State<ListMoreMoviesWidget> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Truyền data chỗ này "),
      ),
      body: GridView.builder(
          padding: EdgeInsets.all(20) // khoảng cách xung quanh
          ,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // sô cột
              crossAxisSpacing: 10, // khoảng cách ngang giữa các ô
              mainAxisSpacing: 10, // khoảng cách  dọc giữa các ô
              childAspectRatio: 2 / 3 // tỉ lệ chieurong/chieurong
              ),
          itemCount: 10,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey,
              ),
            );
          }),
    );
  }


  fetchData() async {

  }
}
