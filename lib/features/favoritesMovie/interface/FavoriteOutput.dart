
import '../data/FavoriteResponse.dart';

abstract class FavoriteOutput {
  void execute(FavoriteResponse response);
  getData();
}