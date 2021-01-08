import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/soon_book/services/song_book_services.dart';
import '../../../domain/soon_book/models/song.dart';
import '../../core/failures/server_failures.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../interfaces/i_song_book_local_repository.dart';

@LazySingleton(as: ISongBookLocalPersistentRepository)
class SongBookLocalStorageRepositoryImpl
    implements ISongBookLocalPersistentRepository {
  SongBookLocalStorageRepositoryImpl({@required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  final History_key = "History";
  final Last_song_key = "last_song";

  @override
  Future<Either<ServerFailure, Song>> getSong({
    @required GetSongDataModel getSongDataModel,
  }) async {
    print("BUSCANDO CANCION DESDE CACHE");
    try {
      final _songJson = sharedPreferences.getString(Last_song_key);
      final _song = Song.fromJson(_songJson);

      if (getSongDataModel.artist == _song.artist.name &&
          getSongDataModel.song == _song.name) {
            print("RECUPERANDO CANCION DESDE CACHE");
        return Right(_song);
      }
      return Left(ServerFailure.notFound());
    } catch (e) {
      return Left(ServerFailure.cacheError());
    }
  }

  @override
  Future<Either<ServerFailure, Unit>> saveSong({@required Song song}) async {
    try {
      await sharedPreferences.setString(Last_song_key, song.toJson());
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure.cacheError());
    }
  }

  @override
  Future<Either<ServerFailure, Unit>> clearHistory() async {
    try {
      await _initializeHistory();
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure.cacheError());
    }
  }

  @override
  Future<Either<ServerFailure, Unit>> addToHistory(
      {@required Song song}) async {
    try {
      final _history = await _getHistory();
      _history.add(song);
      final _songList = _history.map((song) => song.toJson()).toList();
      await sharedPreferences.setStringList(History_key, _songList);
      return Right(unit);
    } catch (e) {
      return Left(ServerFailure.cacheError());
    }
  }

  @override
  Future<Either<ServerFailure, List<Song>>> getHistory() async {
    try {
      final _history = await _getHistory();
      return Right(_history);
    } catch (e) {
      return Left(ServerFailure.cacheError());
    }
  }

  Future<List<Song>> _getHistory() async {
    final _historyJson = sharedPreferences.getStringList(History_key);
    var _history = _historyJson.map((song) => Song.fromJson(song)).toList();
    if (_history == null) {
      _history = await _initializeHistory();
    }
    return _history;
  }

  Future<List<Song>> _initializeHistory() async {
    final _emptyList = [];
    await sharedPreferences.setStringList(History_key, _emptyList);
    return _emptyList;
  }
}
