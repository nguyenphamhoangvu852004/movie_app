
import 'ServerData.dart';

class Episode {
  String _serverName;
  List<ServerData> _serverData;

  Episode(this._serverName, this._serverData);

  List<ServerData> get serverData => _serverData;

  set serverData(List<ServerData> value) {
    _serverData = value;
  }

  String get serverName => _serverName;

  set serverName(String value) {
    _serverName = value;
  }

  @override
  String toString() {
    return 'Episode{_serverName: $_serverName, _serverData: $_serverData}';
  }
}
