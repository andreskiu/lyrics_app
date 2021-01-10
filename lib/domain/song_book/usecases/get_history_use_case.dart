import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../infrastructure/core/failures/server_failures.dart';
import '../../core/use_case.dart';
import '../failures/song_book_failures.dart';
import '../models/song.dart';
import '../services/song_book_services.dart';

@lazySingleton
class GetHistoryUseCase extends UseCase<List<Song>, NoParams> {
  final SongBookService service;

  GetHistoryUseCase(this.service);

  @override
  Future<Either<SongBookFailure, List<Song>>> call(
    NoParams params,
  ) async {
    final result = await service.getHistory();

    return result.fold(
      (fail) {
        if (fail.type == ServerFailureTypes.NotFound) {
          return Left(SongBookFailure.notFound());
        }
        return Left(
          SongBookFailure(
            type: SongBookFailureTypes.ServerError,
            details: fail.details,
          ),
        );
      },
      (history) => Right(history),
    );
  }
}
