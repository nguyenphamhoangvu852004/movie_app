import 'package:movie_app/constants/interfaces/ResponseData.dart';

import '../../data/Category.dart';

class GetTypeListResponseData implements ResponseData{
  List<Category> _typeList;

  GetTypeListResponseData(this._typeList);

  List<Category> get typeList => _typeList;

  set typeList(List<Category> value) {
    _typeList = value;
  }
}