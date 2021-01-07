import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
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
      (l) => Left(
        SongBookFailure(
          type: SongBookFailureTypes.ServerError,
          details: l.details,
        ),
      ),
      (r) => Right(r),
    );
  }
}
