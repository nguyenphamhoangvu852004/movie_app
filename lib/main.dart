import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/data/datasource/MovieLocalDataSource.dart';
import 'package:movie_app/data/repository/MovieRepositoryImpl.dart';
import 'package:movie_app/features/favoritesMovie/presenter/GetFavoriteMoviePresenter.dart';
import 'package:movie_app/features/favoritesMovie/useCase/AddFavoriteMovieUseCase.dart';
import 'package:movie_app/features/favoritesMovie/presenter/FavoriteMoviePresenter.dart';
import 'package:movie_app/features/favoritesMovie/presenter/IsFavoriteMoviePresenter.dart';
import 'package:movie_app/features/favoritesMovie/useCase/GetFavoriteMovieUseCase.dart';
import 'package:movie_app/features/favoritesMovie/useCase/RemoveFavoriteMovieUseCase.dart';
import 'package:movie_app/features/getMovieList/GetMovieList.dart';
import 'package:movie_app/ui/components/FavoriteMoviesWindget.dart';
import 'package:movie_app/ui/components/SingleMoviesWidget.dart';
import 'package:movie_app/ui/components/SeriesMoviesWidget.dart';
import 'package:movie_app/ui/components/NewMoviesWidget.dart';
import 'package:movie_app/ui/layouts/Layout.dart';
import 'package:movie_app/features/getNewMovies/GetNewMovies.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMovie.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMoviePresenter.dart';
import 'package:movie_app/features/getNewMovies/GetNewMoviesPresenter.dart';
import 'package:movie_app/ui/screens/HomeScreen.dart';
import 'features/favoritesMovie/useCase/IsFavoriteMovieUseCase.dart';
import 'ui/components/WidgetTree.dart';
import 'features/getMovieList/GetMovieListPresenter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var database = MovieLocalDataSource();
  var repository = MovieRepositoryImpl(database);


  var favoriteMoviePresenter = FavoriteMoviePresenter(); // add remove
  var isFavoriteMoviePresenter = IsFavoriteMoviePresenter(); // check


  var isMovieFavorite = IsFavoriteMovieUseCase(isFavoriteMoviePresenter, repository);
  var addMovieFavorite = AddFavoriteMovieUseCase(favoriteMoviePresenter, repository);
  var removeFavoriteMovie = RemoveFavoriteMovieUseCase(favoriteMoviePresenter, repository);

  var getFavoritePresenter = GetFavoriteMoviePresenter(); // get
  var getFavoriteMovie = GetFavoriteMovieUseCase(getFavoritePresenter, repository);


  var favoriteWidget = FavoriteMoviesWidget(
      getFavoriteMovie,
      getFavoritePresenter,
      removeFavoriteMovie,
      favoriteMoviePresenter);

  var getDetailPresenter = GetDetailMoviePresenter();
  var getDetailMovie = GetDetailMovie(getDetailPresenter);


  List<Movies> listSingleMovies = [];
  var getSingleMoviesPresenter = GetMovieListPresenter(listSingleMovies);
  var getSingleMovies = GetMovieList(getSingleMoviesPresenter);
  var singleMoviesWidget = SingleMoviesWidget("Phim Lẻ", getSingleMovies,
      getSingleMoviesPresenter,
      getDetailMovie,
      getDetailPresenter,
      addMovieFavorite,
      isMovieFavorite,
      removeFavoriteMovie,
      isFavoriteMoviePresenter
  );

  List<Movies> listSeriesMovies = [];
  var getSeriesPresenter = GetMovieListPresenter(listSeriesMovies);
  var getSeriesMovies = GetMovieList(getSeriesPresenter);
  var seriesMoviesWidget = SeriesMoviesWidget("Phim Bộ", getSeriesMovies,
      getSeriesPresenter,
      getDetailMovie,
      getDetailPresenter,
      addMovieFavorite,
      isMovieFavorite,
      removeFavoriteMovie,
      isFavoriteMoviePresenter
  );

  List<Movies> listNewMovies = [];
  var getNewMoviesPresenter = GetNewMoviesPresenter(listNewMovies);
  var getNewMovies = GetNewMovies(getNewMoviesPresenter);

  var newMoviesWidget = NewMoviesWidget("Phim Moi", getNewMovies,
      getNewMoviesPresenter,
      getDetailMovie,
      getDetailPresenter,
      addMovieFavorite,
      isMovieFavorite,
      removeFavoriteMovie,
      isFavoriteMoviePresenter
  );

  final homeScreen = HomeScreen(singleMoviesWidget, seriesMoviesWidget, newMoviesWidget);
  final widgetTree = WidgetTree();


  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.montserratTextTheme(),
    ),
    debugShowCheckedModeBanner: false,
    home: SafeArea(child: Layout(homeScreen, widgetTree, favoriteWidget)),
  ));
}
