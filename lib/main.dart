import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/features/getMovieList/GetMovieList.dart';
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
import 'ui/components/WidgetTree.dart';
import 'features/getMovieList/GetMovieListPresenter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // chi tiet phim
  var getDetailPresenter = GetDetailMoviePresenter();
  var getDetailMovie = GetDetailMovie(getDetailPresenter);

  // widget load thêm phim lẻ
  var listMoreSingleMoviesWidgetPresenter = GetMovieListPresenter();
  var listMoreSingleMoviesWidgetUseCase = GetMovieList(listMoreSingleMoviesWidgetPresenter);
  var listMoreSingleMoviesWidget = ListMoreMoviesWidget(listMoreSingleMoviesWidgetUseCase, listMoreSingleMoviesWidgetPresenter, getDetailMovie, getDetailPresenter);

  // phim lẻ
  var getSingleMoviesPresenter = GetMovieListPresenter();
  var getSingleMovies = GetMovieList(getSingleMoviesPresenter);
  var singleMoviesWidget = SingleMoviesWidget( getSingleMovies,
      getSingleMoviesPresenter, getDetailMovie, getDetailPresenter,
      listMoreSingleMoviesWidget);


  // widget load thêm phim lẻ
  var listMoreSeriesMoviesWidgetPresenter = GetMovieListPresenter();
  var listMoreSeriesMoviesWidgetUseCase = GetMovieList(listMoreSeriesMoviesWidgetPresenter);
  var listMoreSeriesMoviesWidget = ListMoreMoviesWidget(listMoreSeriesMoviesWidgetUseCase, listMoreSeriesMoviesWidgetPresenter, getDetailMovie, getDetailPresenter);


  // phim bộ
  var getSeriesPresenter = GetMovieListPresenter();
  var getSeriesMovies = GetMovieList(getSeriesPresenter);
  var seriesMoviesWidget = SeriesMoviesWidget(getSeriesMovies,
      getSeriesPresenter, getDetailMovie, getDetailPresenter);

  // Slide Phim mới
  var getNewMoviesPresenter = GetNewMoviesPresenter();
  var getNewMovies = GetNewMovies(getNewMoviesPresenter);

  var newMoviesWidget = NewMoviesWidget(getNewMovies,
      getNewMoviesPresenter, getDetailMovie, getDetailPresenter);



  // trong Home Screen có các widget
  final homeScreen = HomeScreen(singleMoviesWidget, seriesMoviesWidget, newMoviesWidget );

  final widgetTree = WidgetTree();

  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.montserratTextTheme(),
    ),
    debugShowCheckedModeBanner: false,

    //layout
    home: SafeArea(child: Layout(homeScreen, widgetTree)),
  ));
}
