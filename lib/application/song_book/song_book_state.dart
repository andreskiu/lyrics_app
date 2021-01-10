import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../domain/song_book/failures/song_book_failures.dart';
import '../../domain/core/failures.dart';
import '../../domain/core/use_case.dart';
import '../../domain/song_book/models/song.dart';
import '../../domain/song_book/song_book_objects/song_book_objects.dart';
import '../../domain/song_book/usecases/get_history_use_case.dart';

import '../../domain/song_book/usecases/get_lyrics_use_case.dart';

@lazySingleton
class SongBookState extends ChangeNotifier with SongBookFailureManager {
  SongBookState({
    @required this.getLyricsUseCase,
    @required this.getHistoryUseCase,
  });

  // injections
  final GetLyricsUseCase getLyricsUseCase;
  final GetHistoryUseCase getHistoryUseCase;

  // state

  int index = 0;

  FieldArtistName fieldArtistName;
  FieldSongName fieldSongName;

  Song lastSong;
  bool isLoading = false;
  ErrorContent error;

  void changePage(int index) {
    this.index = index;
    notifyListeners();
  }

  Future<bool> getLyrics() async {
    isLoading = true;
    notifyListeners();

    final _params = GetLyricsParams(
      artistName: fieldArtistName,
      songName: fieldSongName,
    );

    final lyricsOrFailure = await getLyricsUseCase(_params);

    lyricsOrFailure.fold((fail) {
      error = getSongBookErrorContent(fail);
    }, (song) {
      lastSong = song;
      error = null;
    });

    isLoading = false;
    notifyListeners();

    return lyricsOrFailure.isRight();
  }

  Future<void> getHistory() async {
    final lyricsOrFailure = await getHistoryUseCase(NoParams());

    lyricsOrFailure.fold((fail) => null, (song) => null);
    notifyListeners();
  }

  void setFieldsFromLatestSong() {
    fieldArtistName = FieldArtistName(lastSong.artist.name);
    fieldSongName = FieldSongName(lastSong.name);
  }
}
