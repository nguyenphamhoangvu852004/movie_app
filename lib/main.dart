import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/data/Category.dart';
import 'package:movie_app/data/Country.dart';
import 'package:movie_app/data/DetailMovies.dart';
import 'package:movie_app/data/Movies.dart';
import 'package:movie_app/features/getCountryList/GetCountryList.dart';
import 'package:movie_app/features/getCountryList/GetCountryListPresenter.dart';
import 'package:movie_app/features/getSingleMovies/GetSingleMovies.dart';
import 'package:movie_app/features/getTypeList/GetTypeList.dart';
import 'package:movie_app/features/getTypeList/GetTypeListPresenter.dart';
import 'package:movie_app/features/getTypeList/GetTypeListRequestData.dart';
import 'package:movie_app/ui/components/GetCountryListWidget.dart';
import 'package:movie_app/ui/components/SingleMoviesWidget.dart';
import 'package:movie_app/ui/components/SeriesMoviesWidget.dart';
import 'package:movie_app/ui/components/NewMoviesWidget.dart';
import 'package:movie_app/ui/components/TypeListWidget.dart';
import 'package:movie_app/ui/layouts/Layout.dart';
import 'package:movie_app/features/getNewMovies/GetNewMovies.dart';
import 'package:movie_app/features/getSeriesMovies/GetSeriesMovies.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMovie.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMoviePresenter.dart';
import 'package:movie_app/features/getSingleMovies/GetSingleMoviesPresenter.dart';
import 'package:movie_app/features/getNewMovies/GetNewMoviesPresenter.dart';
import 'package:movie_app/ui/screens/FindMovieScreen.dart';
import 'package:movie_app/ui/screens/HomeScreen.dart';

import 'features/authentication/WidgetTree.dart';
import 'features/getSeriesMovies/GetSeriesMoviesPresenter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();


  var getDetailPresenter = GetDetailMoviePresenter();
  var getDetailMovie = GetDetailMovie(getDetailPresenter);

  List<Movies> listSingleMovies = [];
  var getSingleMoviesPresenter = GetSingleMoviesPresenter(listSingleMovies);
  var getSingleMovies = GetSingleMovies(getSingleMoviesPresenter);
  var singleMoviesWidget = SingleMoviesWidget("Phim Lẻ", getSingleMovies,
      getSingleMoviesPresenter, getDetailMovie, getDetailPresenter);

  List<Movies> listSeriesMovies = [];
  var getSeriesPresenter = GetSeriesMoviesPresenter(listSeriesMovies);
  var getSeriesMovies = GetSeriesMovies(getSeriesPresenter);
  var seriesMoviesWidget = SeriesMoviesWidget("Phim Bộ", getSeriesMovies,
      getSeriesPresenter, getDetailMovie, getDetailPresenter);

  List<Movies> listNewMovies = [];
  var getNewMoviesPresenter = GetNewMoviesPresenter(listNewMovies);
  var getNewMovies = GetNewMovies(getNewMoviesPresenter);
  var newMoviesWidget = NewMoviesWidget("Phim Moi", getNewMovies,
      getNewMoviesPresenter, getDetailMovie, getDetailPresenter);

  List<Category> typeList = [];
  var getTypeListPresenter = GetTypeListPresenter(typeList);
  var getTypeList = GetTypeList(getTypeListPresenter);
  var getTypeWidget = TypeListWidget(getTypeList, getTypeListPresenter);

  List<Country> countryList = [];
  var getCountryPresenter = GetCountryListPresenter(countryList);
  var getCountryList = GetCountryList(getCountryPresenter);
  var getCountryWidget = GetCountryListWidget(getCountryList, getCountryPresenter);

  final homeScreen = HomeScreen(singleMoviesWidget, seriesMoviesWidget, newMoviesWidget);
  final findScreen = FindMovieScreen(getTypeWidget,getCountryWidget);
  final widgetTree = WidgetTree();

  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.montserratTextTheme(),
    ),
    debugShowCheckedModeBanner: false,
    home: SafeArea(child: Layout(homeScreen,findScreen, widgetTree)),
  ));
}
