class ServerData{
  String _name;
  String _slug;
  String _filename;
  String _link_emebed;
  String _linkm3u8;

  ServerData(this._name, this._slug, this._filename, this._link_emebed,
      this._linkm3u8);

  String get linkm3u8 => _linkm3u8;

  set linkm3u8(String value) {
    _linkm3u8 = value;
  }

  String get link_emebed => _link_emebed;

  set link_emebed(String value) {
    _link_emebed = value;
  }

  String get filename => _filename;

  set filename(String value) {
    _filename = value;
  }

  String get slug => _slug;

  set slug(String value) {
    _slug = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  @override
  String toString() {
    return 'ServerData{_name: $_name, _slug: $_slug, _filename: $_filename, _link_emebed: $_link_emebed, _linkm3u8: $_linkm3u8}';
  }
}