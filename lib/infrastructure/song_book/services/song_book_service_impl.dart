import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../interfaces/i_song_book_local_repository.dart';
import '../interfaces/i_song_book_remote_repository.dart';

import '../../../domain/soon_book/models/song.dart';
import '../../../domain/soon_book/services/song_book_services.dart';
import '../../core/failures/server_failures.dart';

@LazySingleton(as: SongBookService)
class SongBookServiceImpl implements SongBookService {
  final ISongBookLocalVolatileRepository memory;
  final ISongBookLocalPersistentRepository localStorage;
  final ISongBookRemoteRepository server;

  SongBookServiceImpl({
    @required this.memory,
    @required this.localStorage,
    @required this.server,
  });

  @override
  Future<Either<ServerFailure, Song>> getLyrics({
    @required GetSongDataModel getSongDataModel,
  }) async {
    final _songFromMemoryOrFailure =
        await memory.getSong(getSongDataModel: getSongDataModel);

    if (_songFromMemoryOrFailure.isRight()) {
      //song found in memory, no need to update cache
      return _songFromMemoryOrFailure;
    }

    final _songFromCacheOrFailure =
        await localStorage.getSong(getSongDataModel: getSongDataModel);
    if (_songFromMemoryOrFailure.isRight()) {
      //song found in local cache, no need to update cache
      return _songFromCacheOrFailure;
    }

    final _songFromServerOrFailure =
        await server.getLyrics(getSongDataModel: getSongDataModel);

    if (_songFromServerOrFailure.isRight()) {
      final _songFound = _songFromServerOrFailure.getOrElse(() => null);
      await Future.wait([
        _recordSongFound(memory, _songFound),
        _recordSongFound(localStorage, _songFound),
      ]);
    }
    return _songFromServerOrFailure;
  }

  Future<void> _recordSongFound(
    ISongBookLocalRepository repo,
    Song song,
  ) async {
    return Future.wait([
      repo.saveSong(song: song),
      repo.addToHistory(song: song),
    ]);
  }

  @override
  Future<Either<ServerFailure, List<Song>>> getHistory() async {
    final _historyFromMemoryOrFailure = await memory.getHistory();
    final _historyFromMemory =
        _historyFromMemoryOrFailure.getOrElse(() => null);

    if (_historyFromMemory.isNotEmpty) {
      return _historyFromMemoryOrFailure;
    }

    final _historyFromCacheOrFailure = await localStorage.getHistory();

    if (_historyFromCacheOrFailure.isRight()) {
      await memory.clearHistory();
      final _historyFound = _historyFromCacheOrFailure.getOrElse(() => null);

      final _addAllToHistoryWork =
          _historyFound.map((song) => memory.addToHistory(song: song)).toList();

      await Future.wait(_addAllToHistoryWork);
    }
    return _historyFromCacheOrFailure;
  }
}
