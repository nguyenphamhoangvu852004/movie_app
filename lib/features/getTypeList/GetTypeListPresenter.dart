import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/model/Category.dart';

import '../../constants/interfaces/ResponseData.dart';
import 'GetTypeListResponseData.dart';

class GetTypeListPresenter implements OutputBoundary{
  List<Category> data = [];
  @override
  void execute(ResponseData responseData) {
    if (responseData is GetTypeListResponseData) {
      data = responseData.typeList;
    }
  }

  @override
  getData() {
    return data;
  }
}