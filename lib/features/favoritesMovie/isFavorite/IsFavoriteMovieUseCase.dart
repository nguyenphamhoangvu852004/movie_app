
import 'package:movie_app/constants/interfaces/InputBoundary.dart';
import 'package:movie_app/constants/interfaces/OutputBoundary.dart';
import 'package:movie_app/constants/interfaces/RequestData.dart';
import 'package:movie_app/data/repository/MovieRepository.dart';

import 'IsFavoriteRequest.dart';
import 'IsFavoriteResponse.dart';


class IsFavoriteMovieUseCase implements InputBoundary{

  final OutputBoundary _presenter;
  final MovieRepository repository;
  IsFavoriteMovieUseCase(this._presenter, this.repository);

  @override
  execute(RequestData request) async {
    try{
      final data = (request as IsFavoriteRequest);
      final movieId = data.movieId;
      final userId = data.userId;
      bool isExists = await repository.isFavorite(userId!,movieId);

      _presenter.execute(IsFavoriteResponse(isExists));
    }catch(e){
      _presenter.execute(IsFavoriteResponse(false));
    }
  }

}