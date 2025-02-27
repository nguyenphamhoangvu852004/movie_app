import 'package:flutter/material.dart';
import 'package:movie_app/constants/DomainUrl.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:shimmer/shimmer.dart';
import '../../features/getMovieList/GetMovieListRequestData.dart';
import 'DetailMovieWidget.dart';

class SeriesMoviesWidget extends StatefulWidget {
  final String title;
  final InputBoundary getSeriesMovies;
  final OutputBoundary getSeriesMoviesPresenter;
  final InputBoundary getDetailMovies;
  final OutputBoundary getDetailMoviesPresenter;

  const SeriesMoviesWidget(
      this.title, this.getSeriesMovies, this.getSeriesMoviesPresenter, this.getDetailMovies, this.getDetailMoviesPresenter, {super.key});

  @override
  State<SeriesMoviesWidget> createState() => _SeriesMoviesWidgetState();
}

class _SeriesMoviesWidgetState extends State<SeriesMoviesWidget> {
  List<Movies> data = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchSeriesMoviesData(currentPage);

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !isLoadingMore) {
        loadMoreMovies();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            widget.title,
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 230,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: data.length + (isLoadingMore ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == data.length && isLoadingMore) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                );
              }
              return buildMovieCard(data[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget buildMovieCard(Movies movie) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailMovieWidget(
                movie, widget.getDetailMovies, widget.getDetailMoviesPresenter),
          ),
        );
      },
      child: Container(
        width: 130,
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                movie.posterUrl,
                height: 180,
                width: 130,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return shimmerLoadingEffect(130, 180);
                },
              ),
            ),
            SizedBox(height: 6.0),
            Text(
              movie.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerLoadingEffect(double width, double height) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    );
  }

  void fetchSeriesMoviesData(int page) async {
    setState(() => isLoadingMore = true);
    var requestData = GetMovieListRequestData(APP_DOMAIN_API_DS_PHIM_BO,page);
    await widget.getSeriesMovies.execute(requestData);
    setState(() {
      if (page == 1) data.clear();
      data.addAll(widget.getSeriesMoviesPresenter.getData());
      isLoadingMore = false;
    });
  }

  void loadMoreMovies() {
    currentPage++;
    fetchSeriesMoviesData(currentPage);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
