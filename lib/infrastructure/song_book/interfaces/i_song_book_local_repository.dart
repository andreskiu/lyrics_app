import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/song_book/services/song_book_services.dart';
import '../../core/failures/server_failures.dart';
import '../../../domain/song_book/models/song.dart';

abstract class ISongBookLocalRepository {
  Future<Either<ServerFailure, Song>> getSong({
    @required GetSongDataModel getSongDataModel,
  });

  Future<Either<ServerFailure, Unit>> saveSong({
    @required Song song,
  });

  Future<Either<ServerFailure, List<Song>>> getHistory();
  Future<Either<ServerFailure, Unit>> clearHistory();
  Future<Either<ServerFailure, Unit>> addToHistory({
    @required Song song,
  });
}

abstract class ISongBookLocalPersistentRepository
    extends ISongBookLocalRepository {}

abstract class ISongBookLocalVolatileRepository
    extends ISongBookLocalRepository {}