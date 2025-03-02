
import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/features/getNewMovies/GetNewMoviesRequestData.dart';
import 'package:movie_app/ui/components/DetailMovieWidget.dart';
import 'dart:async';

import '../../model/Movies.dart';

class NewMoviesWidget extends StatefulWidget {

  final InputBoundary getNewMovies;
  final OutputBoundary getNewMoviesPresenter;
  final InputBoundary getDetailMovies;
  final OutputBoundary getDetailMoviesPresenter;

  const NewMoviesWidget(this.getNewMovies, this.getNewMoviesPresenter,
      this.getDetailMovies, this.getDetailMoviesPresenter, {super.key});

  @override
  State<NewMoviesWidget> createState() => _NewMoviesWidgetState();
}

class _NewMoviesWidgetState extends State<NewMoviesWidget> {
  List<Movies> data = [];
  int currentPage = 1;
  final PageController _pageController = PageController(viewportFraction: 0.9);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    fetchSeriesMoviesData(currentPage);

    // Tự động chuyển trang sau mỗi 3 giây
    _timer = Timer.periodic(Duration(seconds: 3), (Timer timer) {
      if (_pageController.hasClients && data.isNotEmpty) {
        int nextPage = _pageController.page!.toInt() + 1;
        if (nextPage >= data.length) {
          nextPage = 0;
        }
        _pageController.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(child: CircularProgressIndicator(color: Colors.blueAccent));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Banner phim mới cập nhật
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final Movies movie = data[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailMovieWidget(
                        movie,
                        widget.getDetailMovies,
                        widget.getDetailMoviesPresenter,
                      ),
                    ),
                  );
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Stack(
                      children: [
                        Image.network(
                          'https://phimimg.com/${movie.posterUrl}',
                          width: double.infinity,
                          height: 220,
                          fit: BoxFit.cover,
                        ),
                        // Hiệu ứng mờ gradient
                        Positioned.fill(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.6),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.6)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        // Tên phim
                        Positioned(
                          bottom: 20,
                          left: 15,
                          child: Text(
                            movie.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 4,
                                  color: Colors.black45,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void fetchSeriesMoviesData(int defaultPage) async {
    var reqData = GetNewMoviesRequestData(defaultPage.toString());
    await widget.getNewMovies.execute(reqData);

    setState(() {
      data = widget.getNewMoviesPresenter.getData();
    });
  }
}
