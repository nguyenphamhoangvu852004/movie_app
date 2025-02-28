import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/features/getMovieList/GetMovieList.dart';
import 'package:movie_app/ui/components/SingleMoviesWidget.dart';
import 'package:movie_app/ui/components/SeriesMoviesWidget.dart';
import 'package:movie_app/ui/components/NewMoviesWidget.dart';
import 'package:movie_app/ui/layouts/Layout.dart';
import 'package:movie_app/features/getNewMovies/GetNewMovies.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMovie.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMoviePresenter.dart';
import 'package:movie_app/features/getNewMovies/GetNewMoviesPresenter.dart';
import 'package:movie_app/ui/screens/HomeScreen.dart';
import 'ui/components/WidgetTree.dart';
import 'features/getMovieList/GetMovieListPresenter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var getDetailPresenter = GetDetailMoviePresenter();
  var getDetailMovie = GetDetailMovie(getDetailPresenter);

  List<Movies> listSingleMovies = [];
  var getSingleMoviesPresenter = GetMovieListPresenter(listSingleMovies);
  var getSingleMovies = GetMovieList(getSingleMoviesPresenter);
  var singleMoviesWidget = SingleMoviesWidget("Phim Lẻ", getSingleMovies,
      getSingleMoviesPresenter, getDetailMovie, getDetailPresenter);

  List<Movies> listSeriesMovies = [];
  var getSeriesPresenter = GetMovieListPresenter(listSeriesMovies);
  var getSeriesMovies = GetMovieList(getSeriesPresenter);
  var seriesMoviesWidget = SeriesMoviesWidget("Phim Bộ", getSeriesMovies,
      getSeriesPresenter, getDetailMovie, getDetailPresenter);

  List<Movies> listNewMovies = [];
  var getNewMoviesPresenter = GetNewMoviesPresenter(listNewMovies);
  var getNewMovies = GetNewMovies(getNewMoviesPresenter);

  var newMoviesWidget = NewMoviesWidget("Phim Moi", getNewMovies,
      getNewMoviesPresenter, getDetailMovie, getDetailPresenter);

  final homeScreen = HomeScreen(singleMoviesWidget, seriesMoviesWidget, newMoviesWidget);
  final widgetTree = WidgetTree();

  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.montserratTextTheme(),
    ),
    debugShowCheckedModeBanner: false,
    home: SafeArea(child: Layout(homeScreen, widgetTree)),
  ));
}
