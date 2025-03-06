import 'package:flutter/material.dart';
import 'package:movie_app/constants/DomainUrl.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/features/getMovieList/GetMovieListRequestData.dart';
import 'package:movie_app/ui/components/ListMoreMoviesWidget.dart';
import 'package:shimmer/shimmer.dart';
import '../../../constants/interfaces/InputBoundary.dart';
import '../../model/Movies.dart';
import 'DetailMovieWidget.dart';

class SingleMoviesWidget extends StatefulWidget {
  final InputBoundary getMoviesUseCase;
  final OutputBoundary getMoviesPresenter;
  final InputBoundary getDetailMovies;
  final OutputBoundary getDetailMoviesPresenter;

  final InputBoundary addMovieFavorite;
  final InputBoundary isMovieFavorite;
  final InputBoundary removeMovieFavorite;
  final OutputBoundary isFavoriteMoviePresenter;

  const SingleMoviesWidget(
      this.getMoviesUseCase,
      this.getMoviesPresenter,
      this.getDetailMovies,
      this.getDetailMoviesPresenter,
      this.addMovieFavorite,
      this.isMovieFavorite,
      this.removeMovieFavorite,
      this.isFavoriteMoviePresenter,
      {super.key});

  @override
  State<SingleMoviesWidget> createState() => _SingleMoviesWidgetState();
}

class _SingleMoviesWidgetState extends State<SingleMoviesWidget> {
  List<Movies> data = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchMoviesData();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween, // Đẩy 2 bên ra 2 đầu
            children: [
              const Text(
                "Phim Lẻ",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ListMoreMoviesWidget(
                              widget.getMoviesUseCase,
                              widget.getMoviesPresenter,
                              widget.getDetailMovies,
                              widget.getDetailMoviesPresenter,
                              APP_DOMAIN_API_DS_PHIM_LE,
                              widget.addMovieFavorite,
                              widget.isMovieFavorite,
                              widget.removeMovieFavorite,
                              widget.isFavoriteMoviePresenter
                          )));
                  print("Xem Thêm được nhấn");
                },
                child: const Text(
                  "Xem Thêm",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : data.isEmpty
                  ? const Center(
                      child: Text("Không có dữ liệu",
                          style: TextStyle(color: Colors.white)))
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.length,
                      itemBuilder: (context, index) =>
                          buildMovieCard(data[index]),
                    ),
        ),
      ],
    );
  }

  Widget buildMovieCard(Movies movie) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailMovieWidget(
              movie,
              widget.getDetailMovies,
              widget.getDetailMoviesPresenter,
              widget.addMovieFavorite,
              widget.isMovieFavorite,
              widget.removeMovieFavorite,
              widget.isFavoriteMoviePresenter,
          ),
        ),
      ),
      child: Container(
        width: 130,
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                movie.posterUrl,
                height: 180,
                width: 130,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) =>
                    loadingProgress == null ? child : shimmerLoadingEffect(),
              ),
            ),
            Text(
              movie.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget shimmerLoadingEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[600]!,
      child: Container(
        width: 130,
        height: 180,
        color: Colors.black,
      ),
    );
  }

  void fetchMoviesData() async {
    setState(() => isLoading = true);
    var requestData = GetMovieListRequestData(APP_DOMAIN_API_DS_PHIM_LE,
        APP_DEFAULT_PAGE, APP_DEFAULT_ITEM_PER_PAGE_HOME);
    await widget.getMoviesUseCase.execute(requestData);
    setState(() {
      data = widget.getMoviesPresenter.getData();
      isLoading = false;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
