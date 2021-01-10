import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics_app/application/song_book/history_state.dart.dart';
import 'package:lyrics_app/application/song_book/song_book_state.dart';
import 'package:lyrics_app/domain/core/failures.dart';
import 'package:lyrics_app/domain/core/use_case.dart';
import 'package:lyrics_app/domain/song_book/failures/song_book_failures.dart';
import 'package:lyrics_app/domain/song_book/models/artist.dart';
import 'package:lyrics_app/domain/song_book/models/song.dart';
import 'package:lyrics_app/domain/song_book/usecases/get_history_use_case.dart';
import 'package:lyrics_app/domain/song_book/usecases/get_lyrics_use_case.dart';
import 'package:lyrics_app/infrastructure/core/failures/server_failures.dart';
import 'package:mockito/mockito.dart';

class GetLyricsUseCaseMock extends Mock implements GetLyricsUseCase {}

class GetHistoryUseCaseMock extends Mock implements GetHistoryUseCase {}

void main() {
  GetLyricsUseCaseMock getLyricsUseCaseMock;
  GetHistoryUseCaseMock getHistoryUseCaseMock;
  HistoryState state;
  const _validSongName = "Los Dinosaurios";
  const _validArtistName = "Charly Garcia";
  const _lyrics = "This is a real lyrics";

  setUp(() {
    getHistoryUseCaseMock = GetHistoryUseCaseMock();
    getLyricsUseCaseMock = GetLyricsUseCaseMock();
  });
  group('Get History', () {
    test('Checking Initialization - success path', () async {
      final _song1 = Song(
        lyrics: _lyrics,
        name: _validSongName,
        artist: Artist(
          name: _validArtistName,
        ),
      );

      final _response = [_song1];
      when(getHistoryUseCaseMock(NoParams()))
          .thenAnswer((_) async => Right(_response));

      state = HistoryState(
        getHistoryUseCase: getHistoryUseCaseMock,
        getLyricsUseCase: getLyricsUseCaseMock,
      );

      state.addListener(() {
        expect(state.error, null);
        expect(state.history, _response);
        verify(getHistoryUseCaseMock(NoParams()));

        verifyNoMoreInteractions(getHistoryUseCaseMock);
        verifyZeroInteractions(getLyricsUseCaseMock);
      });
    });

    test('Checking Initialization - Failure path', () async {
      // final _song1 = Song(
      //   lyrics: _lyrics,
      //   name: _validSongName,
      //   artist: Artist(
      //     name: _validArtistName,
      //   ),
      // );
      final _error = ErrorContent(
        message: "wild bug appeared",
        errorCode: 123,
      );

      // final _response = [_song1];
      when(getHistoryUseCaseMock(NoParams())).thenAnswer(
          (_) async => Left(SongBookFailure.serverError(errorContent: _error)));

      state = HistoryState(
        getHistoryUseCase: getHistoryUseCaseMock,
        getLyricsUseCase: getLyricsUseCaseMock,
      );

      state.addListener(() {
        expect(state.error, _error);
        expect(state.history, null);
        verify(getHistoryUseCaseMock(NoParams()));

        verifyNoMoreInteractions(getHistoryUseCaseMock);
        verifyZeroInteractions(getLyricsUseCaseMock);
      });
    });
  });
}
