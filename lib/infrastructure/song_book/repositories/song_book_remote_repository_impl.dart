import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../core/api/dio_error_manager.dart';
import '../../core/api/api.dart';
import '../../../domain/soon_book/models/artist.dart';
import '../../../domain/soon_book/services/song_book_services.dart';
import '../../../domain/soon_book/models/song.dart';
import '../../core/failures/server_failures.dart';
import '../interfaces/i_song_book_remote_repository.dart';

@LazySingleton(as: ISongBookRemoteRepository)
class SongBookRemoteRepository
    with DioErrorManagerMixin
    implements ISongBookRemoteRepository {
  SongBookRemoteRepository({@required this.api});
  final Api api;

  @override
  Future<Either<ServerFailure, Song>> getLyrics({
    @required GetSongDataModel getSongDataModel,
  }) async {
    try {
      final resp = await api.client.get(
        '/' + getSongDataModel.artist + "/" + getSongDataModel.song,
      );

      String _lyrics = resp.data['lyrics'];
      if (_lyrics.isEmpty) {
        return Left(ServerFailure.notFound());
      }

      final _song = Song(
        artist: Artist(name: getSongDataModel.artist),
        name: getSongDataModel.song,
        lyrics: resp.data['lyrics'],
      );
      return Right(_song);
    } on DioError catch (e) {
      return Left(manageDioError(e));
    } on FormatException {
      return Left(ServerFailure.formatFailure());
    } catch (e) {
      return Left(ServerFailure.general());
    }
  }
}
