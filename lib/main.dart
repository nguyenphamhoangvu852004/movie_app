import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/features/favoritesMovie/getFavorite/GetFavoriteMoviePresenter.dart';
import 'package:movie_app/features/favoritesMovie/getFavorite/GetFavoriteMovieUseCase.dart';
import 'package:movie_app/features/getMovieList/GetMovieList.dart';
import 'package:movie_app/ui/components/FavoriteMoviesWindget.dart';
import 'package:movie_app/ui/components/ListMoreMoviesWidget.dart';
import 'package:movie_app/ui/components/SingleMoviesWidget.dart';
import 'package:movie_app/ui/components/SeriesMoviesWidget.dart';
import 'package:movie_app/ui/components/NewMoviesWidget.dart';
import 'package:movie_app/ui/layouts/Layout.dart';
import 'package:movie_app/features/getNewMovies/GetNewMovies.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMovie.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMoviePresenter.dart';
import 'package:movie_app/features/getNewMovies/GetNewMoviesPresenter.dart';
import 'package:movie_app/ui/screens/HomeScreen.dart';
import 'data/datasource/MovieLocalDataSource.dart';
import 'data/repository/MovieRepositoryImpl.dart';
import 'features/favoritesMovie/addFavorite/AddFavoriteMovieUseCase.dart';
import 'features/favoritesMovie/addFavorite/FavoriteMoviePresenter.dart';
import 'features/favoritesMovie/isFavorite/IsFavoriteMoviePresenter.dart';
import 'features/favoritesMovie/isFavorite/IsFavoriteMovieUseCase.dart';
import 'features/favoritesMovie/removeFavorite/RemoveFavoriteMovieUseCase.dart';
import 'ui/components/WidgetTree.dart';
import 'features/getMovieList/GetMovieListPresenter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Database SQL lite
  var database = MovieLocalDataSource();

  // Favorite Repository
  var repository = MovieRepositoryImpl(database);

  // Presenter
  var favoriteMoviePresenter = FavoriteMoviePresenter(); // add remove
  var isFavoriteMoviePresenter = IsFavoriteMoviePresenter(); // check
  var getFavoriteMoviePresenter = GetFavoriteMoviePresenter();

  // UseCase
  var isMovieFavorite = IsFavoriteMovieUseCase(isFavoriteMoviePresenter, repository);
  var addMovieFavorite = AddFavoriteMovieUseCase(favoriteMoviePresenter, repository);
  var removeFavoriteMovie = RemoveFavoriteMovieUseCase(favoriteMoviePresenter, repository);
  var getFavoriteMovie = GetFavoriteMovieUseCase(getFavoriteMoviePresenter, repository);





  // chi tiet phim
  var getDetailPresenter = GetDetailMoviePresenter();
  var getDetailMovie = GetDetailMovie(getDetailPresenter);

  var favoriteWidget = FavoriteMoviesWidget(
      getFavoriteMovie,
      getFavoriteMoviePresenter,
      removeFavoriteMovie,
      favoriteMoviePresenter);

  // phim lẻ
  var getSingleMoviesPresenter = GetMovieListPresenter();
  var getSingleMovies = GetMovieList(getSingleMoviesPresenter);
  var singleMoviesWidget = SingleMoviesWidget(
    getSingleMovies,
    getSingleMoviesPresenter,
    getDetailMovie,
    getDetailPresenter,
    addMovieFavorite,
    isMovieFavorite,
    removeFavoriteMovie,
    isFavoriteMoviePresenter
  );

  // phim bộ
  var getSeriesPresenter = GetMovieListPresenter();
  var getSeriesMovies = GetMovieList(getSeriesPresenter);
  var seriesMoviesWidget = SeriesMoviesWidget(
      getSeriesMovies,
      getSeriesPresenter,
      getDetailMovie,
      getDetailPresenter,
      addMovieFavorite,
      isMovieFavorite,
      removeFavoriteMovie,
      isFavoriteMoviePresenter
  );

  // Slide Phim mới
  var getNewMoviesPresenter = GetNewMoviesPresenter();
  var getNewMovies = GetNewMovies(getNewMoviesPresenter);

  var newMoviesWidget = NewMoviesWidget(getNewMovies,
      getNewMoviesPresenter);

  // trong Home Screen có các widget
  final homeScreen = HomeScreen(singleMoviesWidget, seriesMoviesWidget, newMoviesWidget );

  final widgetTree = WidgetTree();

  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.montserratTextTheme(),
    ),
    debugShowCheckedModeBanner: false,

    //layout
    home: SafeArea(child: Layout(homeScreen, widgetTree, favoriteWidget)),
  ));
}
