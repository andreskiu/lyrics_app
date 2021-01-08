import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../infrastructure/core/failures/server_failures.dart';
import '../song_book_objects/song_book_objects.dart';
import '../../core/use_case.dart';
import '../failures/song_book_failures.dart';
import '../models/song.dart';
import '../services/song_book_services.dart';

@lazySingleton
class GetLyricsUseCase extends UseCase<Song, GetLyricsParams> {
  final SongBookService service;

  GetLyricsUseCase(this.service);

  @override
  Future<Either<SongBookFailure, Song>> call(
    GetLyricsParams params,
  ) async {
    if (!params.areValid()) {
      return Left(SongBookFailure.invalidParams());
    }

    final result = await service.getLyrics(
      getSongDataModel: params.toGetSongDataModel(),
    );

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
      (song) => Right(song),
    );
  }
}

class GetLyricsParams extends Equatable {
  final FieldArtistName artistName;
  final FieldSongName songName;

  GetLyricsParams({
    @required this.artistName,
    @required this.songName,
  });

  bool areValid() {
    return artistName.isValid() && songName.isValid();
  }

  GetSongDataModel toGetSongDataModel() {
    return GetSongDataModel(
      artist: artistName.getValue(),
      song: songName.getValue(),
    );
  }

  @override
  List<Object> get props => [
        artistName,
        songName,
      ];
}
