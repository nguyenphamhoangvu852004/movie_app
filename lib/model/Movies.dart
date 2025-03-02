



import 'package:movie_app/model/Category.dart';
import 'package:movie_app/model/Country.dart';

class Movies {
  String _id;
  String _name;
  String _slug;
  String _originName;
  String _type;
  String _posterUrl;
  String _thumbUrl;
  bool _subDocQuyen;
  bool _chieuRap;
  String _time;
  String _episodeCurrent;
  String _qualiry;
  String _lang;
  int _year;
  List<Category> _categories;
  List<Country> _countries;
  Movies(
      this._id,
      this._name,
      this._slug,
      this._originName,
      this._type,
      this._posterUrl,
      this._thumbUrl,
      this._subDocQuyen,
      this._chieuRap,
      this._time,
      this._episodeCurrent,
      this._qualiry,
      this._lang,
      this._year,
      this._categories,
      this._countries);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  @override
  String toString() {
    return 'Movies{_id: $_id, _name: $_name, _slug: $_slug, _originName: $_originName, _type: $_type, _posterUrl: $_posterUrl, _thumbUrl: $_thumbUrl, _subDocQuyen: $_subDocQuyen, _chieuRap: $_chieuRap, _time: $_time, _episodeCurrent: $_episodeCurrent, _qualiry: $_qualiry, _lang: $_lang, _year: $_year}';
  }

  String get name => _name;

  int get year => _year;

  set year(int value) {
    _year = value;
  }

  String get lang => _lang;

  set lang(String value) {
    _lang = value;
  }

  String get qualiry => _qualiry;

  set qualiry(String value) {
    _qualiry = value;
  }

  String get episodeCurrent => _episodeCurrent;

  set episodeCurrent(String value) {
    _episodeCurrent = value;
  }

  String get time => _time;

  set time(String value) {
    _time = value;
  }

  bool get chieuRap => _chieuRap;

  set chieuRap(bool value) {
    _chieuRap = value;
  }

  bool get subDocQuyen => _subDocQuyen;

  set subDocQuyen(bool value) {
    _subDocQuyen = value;
  }

  String get thumbUrl => _thumbUrl;

  set thumbUrl(String value) {
    _thumbUrl = value;
  }

  String get posterUrl => _posterUrl;

  set posterUrl(String value) {
    _posterUrl = value;
  }

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  String get originName => _originName;

  set originName(String value) {
    _originName = value;
  }

  String get slug => _slug;

  set slug(String value) {
    _slug = value;
  }

  set name(String value) {
    _name = value;
  }

  List<Category> get categories => _categories;

  set categories(List<Category> value) {
    _categories = value;
  }

  List<Country> get countries => _countries;

  set countries(List<Country> value) {
    _countries = value;
  }
}


