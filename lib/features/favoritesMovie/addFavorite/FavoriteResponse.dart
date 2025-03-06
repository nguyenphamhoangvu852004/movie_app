import 'package:movie_app/constants/interfaces/ResponseData.dart';

class FavoriteResponse extends ResponseData{
  final bool success;
  final String message;
  FavoriteResponse({required this.success, required this.message});
}