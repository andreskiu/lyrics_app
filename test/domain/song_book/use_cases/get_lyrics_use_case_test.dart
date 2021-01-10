import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics_app/domain/core/failures.dart';
import 'package:lyrics_app/domain/song_book/failures/song_book_failures.dart';
import 'package:lyrics_app/domain/song_book/models/artist.dart';
import 'package:lyrics_app/domain/song_book/models/song.dart';
import 'package:lyrics_app/domain/song_book/services/song_book_services.dart';
import 'package:lyrics_app/domain/song_book/song_book_objects/song_book_objects.dart';
import 'package:lyrics_app/domain/song_book/usecases/get_lyrics_use_case.dart';
import 'package:lyrics_app/infrastructure/core/failures/server_failures.dart';
import 'package:mockito/mockito.dart';

class SongBookServiceMock extends Mock implements SongBookService {}

void main() {
  GetLyricsUseCase useCase;
  SongBookServiceMock songBookServiceMock;
  const _validSongName = "Los Dinosaurios";
  const _validArtistName = "Charly Garcia";
  const _lyrics = "This is a real lyrics";
  const _invalidSongName = "";
  const _invalidArtistName = "";
  setUp(() {
    songBookServiceMock = SongBookServiceMock();
    useCase = GetLyricsUseCase(songBookServiceMock);
  });
  group('Get lyrics use case', () {
    test('Success Path', () async {
      final _params = GetLyricsParams(
        artistName: FieldArtistName(_validArtistName),
        songName: FieldSongName(_validSongName),
      );
      final _response = Song(
        lyrics: _lyrics,
        name: _validSongName,
        artist: Artist(
          name: _validArtistName,
        ),
      );
      when(songBookServiceMock.getLyrics(
        getSongDataModel: _params.toGetSongDataModel(),
      )).thenAnswer((_) async => Right(_response));
      final _result = await useCase(_params);

      expect(_result, Right(_response));

      verify(songBookServiceMock.getLyrics(
        getSongDataModel: _params.toGetSongDataModel(),
      ));

      verifyNoMoreInteractions(songBookServiceMock);
    });

    group('Failure Path, checking:', () {
      test('Invalid song name', () async {
        final _params = GetLyricsParams(
          artistName: FieldArtistName(_invalidArtistName),
          songName: FieldSongName(_invalidSongName),
        );

        final _result = await useCase(_params);

        expect(_result, Left(SongBookFailure.invalidParams()));
        verifyZeroInteractions(songBookServiceMock);
      });

      test('Song Not found', () async {
        final _params = GetLyricsParams(
          artistName: FieldArtistName(_validArtistName),
          songName: FieldSongName(_validSongName),
        );

        when(songBookServiceMock.getLyrics(
          getSongDataModel: _params.toGetSongDataModel(),
        )).thenAnswer((_) async => Left(ServerFailure.notFound()));
        final _result = await useCase(_params);

        expect(_result, Left(SongBookFailure.notFound()));

        verify(songBookServiceMock.getLyrics(
          getSongDataModel: _params.toGetSongDataModel(),
        ));

        verifyNoMoreInteractions(songBookServiceMock);
      });
      test('other server error', () async {
        final _params = GetLyricsParams(
          artistName: FieldArtistName(_validArtistName),
          songName: FieldSongName(_validSongName),
        );

        final _errorContent = ErrorContent(
          errorCode: 123,
          message: "this is an error message",
        );

        when(songBookServiceMock.getLyrics(
          getSongDataModel: _params.toGetSongDataModel(),
        )).thenAnswer(
          (_) async => Left(
            ServerFailure.badRequest(
              details: _errorContent,
            ),
          ),
        );
        final _result = await useCase(_params);

        expect(
          _result,
          Left(SongBookFailure.serverError(errorContent: _errorContent)),
        );

        verify(songBookServiceMock.getLyrics(
          getSongDataModel: _params.toGetSongDataModel(),
        ));

        verifyNoMoreInteractions(songBookServiceMock);
      });
    });
  });
}
