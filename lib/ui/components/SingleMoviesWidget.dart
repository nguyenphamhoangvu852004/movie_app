import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/features/getSingleMovies/GetSingleMoviesRequestData.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/interfaces/InputBoundary.dart';
import 'DetailMovieWidget.dart';

class SingleMoviesWidget extends StatefulWidget {
  final String title;
  final InputBoundary getSingleMovies;
  final OutputBoundary getSingleMoviesPresenter;
  final InputBoundary getDetailMovies;
  final OutputBoundary getDetailMoviesPresenter;

  const SingleMoviesWidget(
      this.title, this.getSingleMovies, this.getSingleMoviesPresenter, this.getDetailMovies, this.getDetailMoviesPresenter, {super.key});

  @override
  State<SingleMoviesWidget> createState() => _SingleMoviesWidgetState();
}

class _SingleMoviesWidgetState extends State<SingleMoviesWidget> {
  List<Movies> data = [];
  int currentPage = 1;
  bool isLoadingMore = false;
  bool hasMoreData = true;  // To check if there is more data to load
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchSingleMoviesData(currentPage);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !isLoadingMore && hasMoreData) {
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
            itemCount: data.length + (isLoadingMore ? 1 : 0),  // Show loading indicator at the end
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
            builder: (context) => DetailMovieWidget(movie, widget.getDetailMovies, widget.getDetailMoviesPresenter),
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
                'https://phimimg.com/${movie.posterUrl}',
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

  void fetchSingleMoviesData(int page) async {
    if (isLoadingMore) return;

    setState(() => isLoadingMore = true);
    var requestData = GetSingleMoviesRequestData(page);
    await widget.getSingleMovies.execute(requestData);

    setState(() {
      if (page == 1) data.clear();  // Clear existing data on the first page
      data.addAll(widget.getSingleMoviesPresenter.getData());
      isLoadingMore = false;

      if (widget.getSingleMoviesPresenter.getData().isEmpty) {
        hasMoreData = false;
      }
    });
  
  }

  void loadMoreMovies() {
    if (hasMoreData) {
      currentPage++;
      fetchSingleMoviesData(currentPage);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
