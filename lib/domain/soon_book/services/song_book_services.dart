import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../infrastructure/core/failures/server_failures.dart';
import '../models/song.dart';

abstract class SongBookService {
  Future<Either<ServerFailure, Song>> getLyrics({
    @required GetSongDataModel getSongDataModel,
  });

  Future<Either<ServerFailure, List<Song>>> getHistory();
}

class GetSongDataModel extends Equatable {
  final String artist;
  final String song;
  GetSongDataModel({
    @required this.artist,
    @required this.song,
  });

  @override
  List<Object> get props => [song, artist];
}
