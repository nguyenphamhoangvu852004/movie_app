import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';
import 'package:movie_app/data/Country.dart';
import 'package:movie_app/features/getCountryList/GetCountryListResponseData.dart';

class GetCountryListPresenter implements OutputBoundary{
  List<Country> _list;

  GetCountryListPresenter(this._list);

  @override
  void execute(ResponseData responseData) {
    if (responseData is GetCountryListResponseData) {
      _list = responseData.list;
    }
  }

  @override
  getData() {
    return _list;
  }

}