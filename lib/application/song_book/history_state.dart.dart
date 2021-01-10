import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import '../../domain/song_book/models/song.dart';
import '../../domain/song_book/song_book_objects/song_book_objects.dart';
import '../../domain/song_book/usecases/get_lyrics_use_case.dart';
import '../../domain/core/failures.dart';
import '../../domain/core/use_case.dart';
import '../../domain/song_book/usecases/get_history_use_case.dart';

@injectable
class HistoryState extends ChangeNotifier {
  HistoryState({
    @required this.getHistoryUseCase,
    @required this.getLyricsUseCase,
  });

  @factoryMethod
  static Future<HistoryState> init() async {
    final _historyState = HistoryState(
      getHistoryUseCase: GetIt.I<GetHistoryUseCase>(),
      getLyricsUseCase: GetIt.I<GetLyricsUseCase>(),
    );
    await _historyState.getHistory();
    return _historyState;
  }

  // injections
  final GetHistoryUseCase getHistoryUseCase;
  final GetLyricsUseCase getLyricsUseCase;

  // state
  List<Song> history = [];
  ErrorContent error;

  Future<void> getHistory() async {
    final lyricsOrFailure = await getHistoryUseCase(NoParams());

    lyricsOrFailure.fold(
      (fail) => error = fail.details,
      (hist) {
        history = hist;
      },
    );
    notifyListeners();
  }

  Future<Song> getLyrics(String artistName, String songName) async {
    final _params = GetLyricsParams(
      artistName: FieldArtistName(artistName),
      songName: FieldSongName(songName),
    );

    final lyricsOrFailure = await getLyricsUseCase(_params);

    lyricsOrFailure.fold((fail) {
      error = fail.details;
    }, (song) {
      error = null;
    });

    notifyListeners();
    return lyricsOrFailure.getOrElse(() => null);
  }
}
