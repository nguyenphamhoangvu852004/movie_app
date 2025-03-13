import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movie_app/features/authentication/register/Register.dart';
import 'package:movie_app/features/authentication/register/RegisterPresenter.dart';
import 'package:movie_app/features/favoritesMovie/getFavorite/GetFavoriteMoviePresenter.dart';
import 'package:movie_app/features/favoritesMovie/getFavorite/GetFavoriteMovieUseCase.dart';
import 'package:movie_app/features/findListMovie/FindMovieList.dart';
import 'package:movie_app/features/findListMovie/FindMovieListPresenter.dart';
import 'package:movie_app/features/getCountryList/GetCountryList.dart';
import 'package:movie_app/features/getCountryList/GetCountryListPresenter.dart';
import 'package:movie_app/features/getMovieList/GetMovieList.dart';
import 'package:movie_app/features/getTypeList/GetTypeList.dart';
import 'package:movie_app/features/getTypeList/GetTypeListPresenter.dart';
import 'package:movie_app/ui/components/FavoriteMoviesWindget.dart';
import 'package:movie_app/ui/components/SingleMoviesWidget.dart';
import 'package:movie_app/ui/components/SeriesMoviesWidget.dart';
import 'package:movie_app/ui/components/NewMoviesWidget.dart';
import 'package:movie_app/ui/layouts/Layout.dart';
import 'package:movie_app/features/getNewMovies/GetNewMovies.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMovie.dart';
import 'package:movie_app/features/getDetailMovies/GetDetailMoviePresenter.dart';
import 'package:movie_app/features/getNewMovies/GetNewMoviesPresenter.dart';
import 'package:movie_app/ui/screens/FindMovieScreen.dart';
import 'package:movie_app/ui/screens/HomeScreen.dart';
import 'data/datasource/MovieLocalDataSource.dart';
import 'data/repository/MovieRepositoryImpl.dart';
import 'features/authentication/login/Login.dart';
import 'features/authentication/login/LoginPresenter.dart';
import 'features/favoritesMovie/addFavorite/AddFavoriteMovieUseCase.dart';
import 'features/favoritesMovie/addFavorite/FavoriteMoviePresenter.dart';
import 'features/favoritesMovie/isFavorite/IsFavoriteMoviePresenter.dart';
import 'features/favoritesMovie/isFavorite/IsFavoriteMovieUseCase.dart';
import 'features/favoritesMovie/removeFavorite/RemoveFavoriteMovieUseCase.dart';
import 'ui/screens/WidgetTree.dart';
import 'features/getMovieList/GetMovieListPresenter.dart';

void main() async {

  // Database SQL lite
  var database = MovieLocalDataSource();

  // Favorite Repository
  var repository = MovieRepositoryImpl(database);

  // Presenter
  var favoriteMoviePresenter = FavoriteMoviePresenter(); // add remove
  var isFavoriteMoviePresenter = IsFavoriteMoviePresenter(); // check
  var getFavoriteMoviePresenter = GetFavoriteMoviePresenter();

  // UseCase
  var isMovieFavorite =
      IsFavoriteMovieUseCase(isFavoriteMoviePresenter, repository);
  var addMovieFavorite =
      AddFavoriteMovieUseCase(favoriteMoviePresenter, repository);
  var removeFavoriteMovie =
      RemoveFavoriteMovieUseCase(favoriteMoviePresenter, repository);
  var getFavoriteMovie =
      GetFavoriteMovieUseCase(getFavoriteMoviePresenter, repository);

  // chi tiet phim
  var getDetailPresenter = GetDetailMoviePresenter();
  var getDetailMovie = GetDetailMovie(getDetailPresenter);

  var favoriteWidget = FavoriteMoviesWidget(
      getFavoriteMovie,
      getFavoriteMoviePresenter,
      removeFavoriteMovie,
      favoriteMoviePresenter,
      getDetailMovie,
      getDetailPresenter,
      addMovieFavorite,
      isMovieFavorite,
      isFavoriteMoviePresenter);

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
      isFavoriteMoviePresenter);

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
      isFavoriteMoviePresenter);

  // Slide Phim mới
  var getNewMoviesPresenter = GetNewMoviesPresenter();
  var getNewMovies = GetNewMovies(getNewMoviesPresenter);

  var newMoviesWidget = NewMoviesWidget(getNewMovies, getNewMoviesPresenter);

  var getTypeListPresenter = GetTypeListPresenter();
  var getTypeListUseCase = GetTypeList(getTypeListPresenter);
  var getCountryListPresenter = GetCountryListPresenter();
  var getCountryListUseCase = GetCountryList(getCountryListPresenter);
  var findListMoviePresenter = FindMovieListPresenter();
  var findListMovieUseCase = FindMovieList(findListMoviePresenter);
  var findMovieScreen = FindMovieScreen(
      getTypeListUseCase,
      getTypeListPresenter,
      getCountryListUseCase,
      getCountryListPresenter,
      findListMovieUseCase,
      findListMoviePresenter,
      getDetailMovie,
      getDetailPresenter,
      addMovieFavorite,
      isMovieFavorite,
      removeFavoriteMovie,
      isFavoriteMoviePresenter
  );

  // trong Home Screen có các widget
  final homeScreen =
      HomeScreen(singleMoviesWidget, seriesMoviesWidget, newMoviesWidget);


  final registerPresenter = RegisterPresenter();
  final register = Register(registerPresenter,repository);
  final loginPresenter = LoginPresenter();
  final login = Login(loginPresenter,repository);
  final widgetTree = WidgetTree(register,registerPresenter, login, loginPresenter);

  runApp(MaterialApp(
    theme: ThemeData(
      textTheme: GoogleFonts.montserratTextTheme(),
    ),
    debugShowCheckedModeBanner: false,

    //layout
    home: SafeArea(
        child: Layout(homeScreen, widgetTree, favoriteWidget, findMovieScreen)),
  ));
}

