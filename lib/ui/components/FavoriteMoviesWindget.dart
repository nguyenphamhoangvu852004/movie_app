import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/model/User.dart';
import 'package:movie_app/ui/components/DetailMovieWidget.dart';
import 'package:movie_app/ui/screens/WidgetTree.dart';

import '../../features/favoritesMovie/addFavorite/FavoriteRequest.dart';
import '../../features/favoritesMovie/getFavorite/EmtyRequest.dart';
import '../../model/Movies.dart';

class FavoriteMoviesWidget extends StatefulWidget {
  final InputBoundary getFavoriteMovies;
  final OutputBoundary getFavoritePresenter;
  final InputBoundary removeFavoriteMovies;
  final OutputBoundary removeFavoritePresenter;

  final InputBoundary getDetailMovie;
  final OutputBoundary getDetailMoviePresenter;
  final InputBoundary addMovieFavorite;
  final InputBoundary isMovieFavorite;
  final OutputBoundary isFavoriteMoviePresenter;

  const FavoriteMoviesWidget(
      this.getFavoriteMovies,
      this.getFavoritePresenter,
      this.removeFavoriteMovies,
      this.removeFavoritePresenter,
      this.getDetailMovie,
      this.getDetailMoviePresenter,
      this.addMovieFavorite,
      this.isMovieFavorite,
      this.isFavoriteMoviePresenter,
      {super.key});

  @override
  _FavoriteMoviesWidgetState createState() => _FavoriteMoviesWidgetState();
}

class _FavoriteMoviesWidgetState extends State<FavoriteMoviesWidget> {
  List<Movies> favoriteMovies = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    if (AuthRepoImp().getCurrentUser() != null) {
      _loadFavoriteMovies();
    }
  }

  Future<void> _loadFavoriteMovies() async {
    setState(() {
      isLoading = true;
    });

    User? user = AuthRepoImp().getCurrentUser();

    if (user == null || user.id == null) {
      setState(() {
        favoriteMovies = [];
        isLoading = false;
      });
      return;
    }

    await widget.getFavoriteMovies.execute(EmptyRequest(user.id!));
    final movies = widget.getFavoritePresenter.getData() as List<Movies>?;

    setState(() {
      favoriteMovies = (movies != null && movies.isNotEmpty) ? movies : [];
      isLoading = false;
    });
  }


  Future<void> _removeFromFavorites(Movies movie) async {
    User? user = AuthRepoImp().getCurrentUser();
    if (user != null && user.id != null) {
      var request = FavoriteRequest(user.id!, movie);
      await widget.removeFavoriteMovies.execute(request);
      await _loadFavoriteMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách yêu thích"),
        backgroundColor: Colors.redAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed:
              _loadFavoriteMovies,
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child:
                  CircularProgressIndicator()) // Hiển thị loading khi đang tải
          : favoriteMovies.isEmpty
              ? Center(child: Text("Chưa có phim yêu thích!"))
              : ListView.builder(
                  itemCount: favoriteMovies.length,
                  itemBuilder: (context, index) {
                    final movie = favoriteMovies[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              movie.posterUrl,
                              width: 50,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(movie.name,
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeFromFavorites(movie),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailMovieWidget(
                                      movie,
                                      widget.getDetailMovie,
                                      widget.getDetailMoviePresenter,
                                      widget.addMovieFavorite,
                                      widget.isMovieFavorite,
                                      widget.removeFavoriteMovies,
                                      widget.isFavoriteMoviePresenter),
                                ));
                          }),
                    );
                  },
                ),
    );
  }
}
