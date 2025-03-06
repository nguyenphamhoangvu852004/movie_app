import 'package:flutter/material.dart';
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';

import '../../features/favoritesMovie/addFavorite/FavoriteRequest.dart';
import '../../features/favoritesMovie/getFavorite/EmtyRequest.dart';
import '../../model/Movies.dart';

class FavoriteMoviesWidget extends StatefulWidget {
  final InputBoundary getFavoriteMovies;
  final OutputBoundary getFavoritePresenter;
  final InputBoundary removeFavoriteMovies;
  final OutputBoundary removeFavoritePresenter;

  const FavoriteMoviesWidget(
      this.getFavoriteMovies,
      this.getFavoritePresenter,
      this.removeFavoriteMovies,
      this.removeFavoritePresenter,
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
    _loadFavoriteMovies();
  }

  Future<void> _loadFavoriteMovies() async {
    setState(() {
      isLoading = true;
    });

    await widget.getFavoriteMovies.execute(EmptyRequest()); // Gửi request để lấy danh sách yêu thích
    final movies = widget.getFavoritePresenter.getData() as List<Movies>?;
    print(movies);

    if (movies != null) {
      setState(() {
        favoriteMovies = movies;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _removeFromFavorites(Movies movie) async {
    var request = FavoriteRequest(movie);
    await widget.removeFavoriteMovies.execute(request);
    _loadFavoriteMovies();
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
            onPressed: _loadFavoriteMovies,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Hiển thị loading khi đang tải
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
              title: Text(movie.name, style: TextStyle(fontWeight: FontWeight.bold)),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => _removeFromFavorites(movie),
              ),
            ),
          );
        },
      ),
    );
  }
}
