import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/soon_book/services/song_book_services.dart';
import '../../../domain/soon_book/models/song.dart';
import '../../core/failures/server_failures.dart';

abstract class ISongBookRemoteRepository {
  Future<Either<ServerFailure, Song>> getLyrics({
    @required GetSongDataModel getSongDataModel,
  });
}
