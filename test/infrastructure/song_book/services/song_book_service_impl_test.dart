import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics_app/domain/song_book/models/artist.dart';
import 'package:lyrics_app/domain/song_book/models/song.dart';
import 'package:lyrics_app/domain/song_book/services/song_book_services.dart';
import 'package:lyrics_app/infrastructure/core/failures/server_failures.dart';
import 'package:lyrics_app/infrastructure/song_book/interfaces/i_song_book_local_repository.dart';
import 'package:lyrics_app/infrastructure/song_book/interfaces/i_song_book_remote_repository.dart';
import 'package:lyrics_app/infrastructure/song_book/services/song_book_service_impl.dart';
import 'package:mockito/mockito.dart';

class ISongBookLocalVolatileRepositoryMock extends Mock
    implements ISongBookLocalVolatileRepository {}

class ISongBookLocalPersistentRepositoryMock extends Mock
    implements ISongBookLocalPersistentRepository {}

class ISongBookRemoteRepositoryMock extends Mock
    implements ISongBookRemoteRepository {}

void main() {
  ISongBookLocalVolatileRepository _memory;
  ISongBookLocalPersistentRepository _localStorage;
  ISongBookRemoteRepository _server;

  SongBookService service;

  const _validSongName = "Los Dinosaurios";
  const _validArtistName = "Charly Garcia";
  const _lyrics = "This is a real lyrics";
  setUp(() {
    _memory = ISongBookLocalVolatileRepositoryMock();
    _localStorage = ISongBookLocalPersistentRepositoryMock();
    _server = ISongBookRemoteRepositoryMock();

    service = SongBookServiceImpl(
      memory: _memory,
      localStorage: _localStorage,
      server: _server,
    );
  });
  group('Song book Service Implementation', () {
    group('get history', () {
      test('retrieve information from memory', () async {
        final _song1 = Song(
          lyrics: _lyrics,
          name: _validSongName,
          artist: Artist(
            name: _validArtistName,
          ),
        );

        final _song2 = Song(
          lyrics: _lyrics,
          name: _validSongName,
          artist: Artist(
            name: _validArtistName,
          ),
        );

        final _response = [_song1, _song2];
        when(_memory.getHistory()).thenAnswer((_) async => Right(_response));

        final _result = await service.getHistory();

        expect(_result, Right(_response));

        verify(_memory.getHistory());

        verifyNoMoreInteractions(_memory);
        verifyZeroInteractions(_localStorage);
        verifyZeroInteractions(_server);
      });

      test('retrieve information from cache', () async {
        final _song1 = Song(
          lyrics: _lyrics,
          name: _validSongName,
          artist: Artist(
            name: _validArtistName,
          ),
        );

        final _song2 = Song(
          lyrics: _lyrics,
          name: _validSongName,
          artist: Artist(
            name: _validArtistName,
          ),
        );

        final _response = [_song1, _song2];
        when(_memory.getHistory()).thenAnswer((_) async => Right([]));

        when(_memory.clearHistory()).thenAnswer((_) async => Right(unit));

        when(_memory.addToHistory(song: _song1))
            .thenAnswer((_) async => Right(unit));

        when(_memory.addToHistory(song: _song2))
            .thenAnswer((_) async => Right(unit));

        when(_localStorage.getHistory())
            .thenAnswer((_) async => Right(_response));

        final _result = await service.getHistory();

        expect(_result, Right(_response));

        verifyInOrder([
          _memory.getHistory(),
          _memory.clearHistory(),
          _memory.addToHistory(song: _song1),
          _memory.addToHistory(song: _song2)
        ]);
        verifyNoMoreInteractions(_memory);

        verify(_localStorage.getHistory());
        verifyNoMoreInteractions(_localStorage);

        verifyZeroInteractions(_server);
      });
    });
  });
}
