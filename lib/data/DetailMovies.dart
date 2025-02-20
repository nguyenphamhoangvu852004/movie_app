import 'package:movie_app/data/Episode.dart';
import 'package:movie_app/data/Movies.dart';

class DetailMovies {
  Movies _movies;
   String _content;
   String _status;
   bool _isCopyright;
   String _trailerUrl;
   String _episodeTotal;
   String _notify;
   String _showtimes;
   int _view;
    List<Episode> _episode;
  DetailMovies(
      this._movies,
      this._content,
      this._status,
      this._isCopyright,
      this._trailerUrl,
      this._episodeTotal,
      this._notify,
      this._showtimes,
      this._view,
      this._episode);

  Movies get movies => _movies;

  set movies(Movies value) {
    _movies = value;
  }

  @override
  String toString() {
    return 'DetailMovies{_movies: $_movies, _content: $_content, _status: $_status, _isCopyright: $_isCopyright, _trailerUrl: $_trailerUrl, _episodeTotal: $_episodeTotal, _notify: $_notify, _showtimes: $_showtimes, _view: $_view, _episode: $_episode}';
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  String get status => _status;

  set status(String value) {
    _status = value;
  }

  bool get isCopyright => _isCopyright;

  set isCopyright(bool value) {
    _isCopyright = value;
  }

  String get trailerUrl => _trailerUrl;

  set trailerUrl(String value) {
    _trailerUrl = value;
  }

  String get episodeTotal => _episodeTotal;

  set episodeTotal(String value) {
    _episodeTotal = value;
  }

  String get notify => _notify;

  set notify(String value) {
    _notify = value;
  }

  String get showtimes => _showtimes;

  set showtimes(String value) {
    _showtimes = value;
  }

  int get view => _view;

  set view(int value) {
    _view = value;
  }

  List<Episode> get episode => _episode;

  set episode(List<Episode> value) {
    _episode = value;
  }
}