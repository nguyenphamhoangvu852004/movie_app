import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/ResponseData.dart';

import '../../data/Category.dart';
import 'GetTypeListResponseData.dart';

class GetTypeListPresenter implements OutputBoundary{
  List<Category> typeList;

  GetTypeListPresenter(this.typeList);

  @override
  void execute(ResponseData responseData) {
    if (responseData is GetTypeListResponseData) {
      typeList = responseData.typeList;
    }
  }

  @override
  getData() {
    return typeList;
  }

}