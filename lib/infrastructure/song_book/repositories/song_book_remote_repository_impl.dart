import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/soon_book/models/artist.dart';
import '../../../domain/soon_book/services/song_book_services.dart';
import '../../../domain/soon_book/models/song.dart';
import '../../core/failures/server_failures.dart';
import '../interfaces/i_song_book_remote_repository.dart';

@LazySingleton(as: ISongBookRemoteRepository)
class SongBookRemoteRepository implements ISongBookRemoteRepository {
  SongBookRemoteRepository({@required this.dio});
  final Dio dio;

  @override
  Future<Either<ServerFailure, Song>> getLyrics({
    @required GetSongDataModel getSongDataModel,
  }) async {
    print("RECUPERANDO CANCION DESDE SERVIDOR");
    return Right(
      Song(
        artist: Artist(name: getSongDataModel.artist),
        name: getSongDataModel.song,
        lyrics: deleteMe,
      ),
    );
  }
}

const deleteMe =
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur viverra libero vitae eleifend fermentum. Aliquam enim elit, bibendum ac diam nec, viverra porttitor ante. Nunc ultricies consectetur libero, vel efficitur dui aliquam nec. Phasellus semper, risus et faucibus interdum, leo est bibendum ipsum, iaculis molestie odio lorem vitae eros. Integer nunc velit, auctor porta faucibus sed, fermentum ut nisi. Nulla id lobortis enim. Morbi at ultricies lorem, id efficitur sapien. Praesent nibh ante, efficitur in pulvinar quis, interdum non felis. Duis tortor justo, ullamcorper a dui viverra, hendrerit vestibulum nisi. Morbi lacinia gravida libero eu laoreet. Proin non arcu vitae sapien tristique auctor. Donec tempus nisl vitae quam tincidunt, at vehicula felis venenatis. Duis vulputate lectus sed tortor pharetra, quis pharetra sem dapibus. Morbi in vehicula dolor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur viverra libero vitae eleifend fermentum. Aliquam enim elit, bibendum ac diam nec, viverra porttitor ante. Nunc ultricies consectetur libero, vel efficitur dui aliquam nec. Phasellus semper, risus et faucibus interdum, leo est bibendum ipsum, iaculis molestie odio lorem vitae eros. Integer nunc velit, auctor porta faucibus sed, fermentum ut nisi. Nulla id lobortis enim. Morbi at ultricies lorem, id efficitur sapien. Praesent nibh ante, efficitur in pulvinar quis, interdum non felis. Duis tortor justo, ullamcorper a dui viverra, hendrerit vestibulum nisi. Morbi lacinia gravida libero eu laoreet. Proin non arcu vitae sapien tristique auctor. Donec tempus nisl vitae quam tincidunt, at vehicula felis venenatis. Duis vulputate lectus sed tortor pharetra, quis pharetra sem dapibus. Morbi in vehicula dolor. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur viverra libero vitae eleifend fermentum. Aliquam enim elit, bibendum ac diam nec, viverra porttitor ante. Nunc ultricies consectetur libero, vel efficitur dui aliquam nec. Phasellus semper, risus et faucibus interdum, leo est bibendum ipsum, iaculis molestie odio lorem vitae eros. Integer nunc velit, auctor porta faucibus sed, fermentum ut nisi. Nulla id lobortis enim. Morbi at ultricies lorem, id efficitur sapien. Praesent nibh ante, efficitur in pulvinar quis, interdum non felis. Duis tortor justo, ullamcorper a dui viverra, hendrerit vestibulum nisi. Morbi lacinia gravida libero eu laoreet. Proin non arcu vitae sapien tristique auctor. Donec tempus nisl vitae quam tincidunt, at vehicula felis venenatis. Duis vulputate lectus sed tortor pharetra, quis pharetra sem dapibus. Morbi in vehicula dolor.";
