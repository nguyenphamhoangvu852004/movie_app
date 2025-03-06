
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/data/repository/MovieRepository.dart';


class FindMoviesUseCase implements InputBoundary{

  final OutputBoundary _presenter;
  final MovieRepository repository;
  FindMoviesUseCase(this._presenter, this.repository);

  @override
  Future<void> execute(RequestData requestData) async {


  }
}