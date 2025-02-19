
import 'package:movie_app/constants/interfaces/ResponseData.dart';

abstract class OutputBoundary {
  void execute(ResponseData responseData);
  getData();
}