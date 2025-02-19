import 'package:movie_app/constants/interfaces/RequestData.dart';

abstract class InputBoundary {
  execute(RequestData requestData);
}