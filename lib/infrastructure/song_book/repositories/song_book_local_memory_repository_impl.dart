import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../interfaces/i_song_book_local_repository.dart';
import '../../../domain/song_book/services/song_book_services.dart';
import '../../../domain/song_book/models/song.dart';
import '../../core/failures/server_failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton(as: ISongBookLocalVolatileRepository)
class SongBookLocalMemoryRepositoryImpl
    implements ISongBookLocalVolatileRepository {
  SongBookLocalMemoryRepositoryImpl({@required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  Song lastSong;
  final _history = <Song>[];

  @override
  Future<Either<ServerFailure, Song>> getSong({
    @required GetSongDataModel getSongDataModel,
  }) async {
    if (lastSong != null &&
        getSongDataModel.artist == lastSong.artist.name &&
        getSongDataModel.song == lastSong.name) {
      return Right(lastSong);
    }
    return Left(ServerFailure.notFound());
  }

  @override
  Future<Either<ServerFailure, Unit>> saveSong({
    @required Song song,
  }) async {
    lastSong = song;
    return Right(unit);
  }

  @override
  Future<Either<ServerFailure, List<Song>>> getHistory() async {
    return Right(_history);
  }

  @override
  Future<Either<ServerFailure, Unit>> addToHistory({
    @required Song song,
  }) async {
    _history.add(song);
    return Right(unit);
  }

  @override
  Future<Either<ServerFailure, Unit>> clearHistory() async {
    _history.removeWhere((song) => true);
    return Right(unit);
  }
}
