import 'package:flutter/material.dart';
import 'package:movie_app/constants/DomainUrl.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/ui/components/ListMoreMoviesWidget.dart';
import 'package:shimmer/shimmer.dart';
import '../../features/getMovieList/GetMovieListRequestData.dart';
import '../../model/Movies.dart';
import 'DetailMovieWidget.dart';

class SeriesMoviesWidget extends StatefulWidget {
  final InputBoundary getMoviesUseCase;
  final OutputBoundary getMoviesPresenter;
  final InputBoundary getDetailMovies;
  final OutputBoundary getDetailMoviesPresenter;

  final InputBoundary addMovieFavorite;
  final InputBoundary isMovieFavorite;
  final InputBoundary removeMovieFavorite;
  final OutputBoundary isFavoriteMoviePresenter;

  const SeriesMoviesWidget(
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
  State<SeriesMoviesWidget> createState() => _SeriesMoviesWidgetState();
}

class _SeriesMoviesWidgetState extends State<SeriesMoviesWidget> {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Phim Bộ",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black),
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
                        APP_DOMAIN_API_DS_PHIM_BO,
                        widget.addMovieFavorite,
                        widget.isMovieFavorite,
                        widget.removeMovieFavorite,
                        widget.isFavoriteMoviePresenter
                      ),
                    ),
                  );
                },
                child: const Text(
                  "Xem Thêm",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 230,
          child: isLoading
              ? const Center(child: CircularProgressIndicator(  color: Colors.black))
              : data.isEmpty
              ? const Center(
              child: Text("Không có dữ liệu", style: TextStyle(color: Colors.black)))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: data.length,
            itemBuilder: (context, index) => buildMovieCard(data[index]),
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
            widget.isFavoriteMoviePresenter
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
                loadingProgress == null ? child : CircularProgressIndicator(color: Colors.black),
              ),
            ),
            Text(
              movie.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }


  void fetchMoviesData() async {
    setState(() => isLoading = true);
    var requestData = GetMovieListRequestData(
        APP_DOMAIN_API_DS_PHIM_BO, APP_DEFAULT_PAGE, APP_DEFAULT_ITEM_PER_PAGE_HOME);
    await widget.getMoviesUseCase.execute(requestData);
    setState(() {
      data = widget.getMoviesPresenter.getData();
      isLoading = false;
    });
  }
}
