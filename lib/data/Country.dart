class Country{
  String _id;
  String _name;
  String _slug;

  Country(this._id, this._name, this._slug);

  String get slug => _slug;

  set slug(String value) {
    _slug = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}