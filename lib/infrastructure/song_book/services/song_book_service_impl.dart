import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/soon_book/models/song.dart';
import '../../../domain/soon_book/services/song_book_services.dart';
import '../../core/failures/server_failures.dart';

@LazySingleton(as: SongBookService)
class SongBookServiceImpl implements SongBookService {
  @override
  Future<Either<ServerFailure, Song>> getLyrics() {
    // TODO: implement getLyrics
    throw UnimplementedError();
  }
}
