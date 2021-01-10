import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lyrics_app/domain/song_book/models/artist.dart';
import 'package:lyrics_app/domain/song_book/models/song.dart';
import 'package:lyrics_app/domain/song_book/services/song_book_services.dart';
import 'package:lyrics_app/infrastructure/core/api/api.dart';
import 'package:lyrics_app/infrastructure/core/failures/server_failures.dart';
import 'package:lyrics_app/infrastructure/song_book/repositories/song_book_remote_repository_impl.dart';
import 'package:mockito/mockito.dart';

// class ApiMock extends Mock implements Api {}

class DioAdapterMock extends Mock implements HttpClientAdapter {}

void main() {
  SongBookRemoteRepository repository;
  Api api;
  Dio dio;
  DioAdapterMock dioAdapterMock;

  const _validSongName = "Los Dinosaurios";
  const _validArtistName = "Charly Garcia";
  const _lyrics = "This is a real lyrics";

  setUp(() {
    dio = Dio();
    dioAdapterMock = DioAdapterMock();
    dio.httpClientAdapter = dioAdapterMock;
    api = ApiImpl(dio: dio, interceptorsWrapper: AppInterceptorsWrapper());
    repository = SongBookRemoteRepository(api: api);
  });

  group('Song book remote repository', () {
    test('Success server response', () async {
      final _params = GetSongDataModel(
        song: _validSongName,
        artist: _validArtistName,
      );
      final _response = Song(
        lyrics: _lyrics,
        name: _validSongName,
        artist: Artist(
          name: _validArtistName,
        ),
      );

      final _httpResponse = ResponseBody.fromString(
        jsonEncode({"lyrics": _lyrics}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => _httpResponse);

      final _result = await repository.getLyrics(getSongDataModel: _params);

      expect(_result, Right(_response));

      verify(dioAdapterMock.fetch(any, any, any));

      verifyNoMoreInteractions(dioAdapterMock);
    });

    test('Server response - Song not found', () async {
      final _params = GetSongDataModel(
        song: _validSongName,
        artist: _validArtistName,
      );
      // final _response = Song(
      //   lyrics: _lyrics,
      //   name: _validSongName,
      //   artist: Artist(
      //     name: _validArtistName,
      //   ),
      // );

      final _httpResponse = ResponseBody.fromString(
        jsonEncode({"lyrics": ""}),
        200,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => _httpResponse);

      final _result = await repository.getLyrics(getSongDataModel: _params);

      expect(_result, Left(ServerFailure.notFound()));

      verify(dioAdapterMock.fetch(any, any, any));

      verifyNoMoreInteractions(dioAdapterMock);
    });

    test('Server response - Other error', () async {
      final _params = GetSongDataModel(
        song: _validSongName,
        artist: _validArtistName,
      );

      final _httpResponse = ResponseBody.fromString(
        "",
        400,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );
      
      when(dioAdapterMock.fetch(any, any, any))
          .thenAnswer((_) async => _httpResponse);

      final _result = await repository.getLyrics(getSongDataModel: _params);

      expect(_result, Left(ServerFailure.badRequest()));

      verify(dioAdapterMock.fetch(any, any, any));

      verifyNoMoreInteractions(dioAdapterMock);
    });
  });
}
