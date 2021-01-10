import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/song_book/services/song_book_services.dart';
import '../../../domain/song_book/models/song.dart';
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
    try {
      final _actualHistory = await _getHistory();
      final _songFound = _actualHistory.firstWhere(
        (storedSong) =>
            getSongDataModel.artist == storedSong.artist.name &&
            getSongDataModel.song == storedSong.name,
        orElse: () => null,
      );

      if (_songFound != null) {
        return Right(_songFound);
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
    if (_historyJson == null) {
      await _initializeHistory();
      return [];
    }
    return _historyJson.map((song) => Song.fromJson(song)).toList();
  }

  Future<List<String>> _initializeHistory() async {
    final _emptyList = <String>[];
    await sharedPreferences.setStringList(History_key, _emptyList);
    return _emptyList;
  }
}
