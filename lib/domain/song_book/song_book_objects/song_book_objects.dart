import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'validators.dart';
import '../../core/value_objects.dart';
import '../failures/song_book_failures.dart';

abstract class PasscodeObject<T> extends ValueObject {
  @override
  Either<SongBookFailure, T> get value;

  @override
  SongBookFailure getError() => value.fold((l) => l, (r) => null);

  @override
  T getValue() => value.getOrElse(() => null);
}

class FieldArtistName extends PasscodeObject<String> {
  factory FieldArtistName(String input) {
    return FieldArtistName._(value: validateArtistName(input));
  }

  FieldArtistName._({
    @required this.value,
  });

  @override
  final Either<SongBookFailure, String> value;
}

class FieldSongName extends PasscodeObject<String> {
  factory FieldSongName(String input) {
    return FieldSongName._(value: validateSongName(input));
  }

  FieldSongName._({
    @required this.value,
  });

  @override
  final Either<SongBookFailure, String> value;
}