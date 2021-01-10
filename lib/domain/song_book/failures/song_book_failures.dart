import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../core/failures.dart';

class SongBookFailure extends Failure<SongBookFailureTypes>
    with EquatableMixin {
  @override
  final SongBookFailureTypes type;
  final ErrorContent details;
  SongBookFailure({
    @required this.type,
    this.details,
  });

  @override
  List<Object> get props => [
        type,
        details,
      ];

  factory SongBookFailure.notFound() {
    return SongBookFailure(type: SongBookFailureTypes.SongNotFound);
  }

  factory SongBookFailure.emptyArtist() {
    return SongBookFailure(type: SongBookFailureTypes.EmptyArtist);
  }

  factory SongBookFailure.emptySongTitle() {
    return SongBookFailure(type: SongBookFailureTypes.EmptySongTitle);
  }

  factory SongBookFailure.invalidParams() {
    return SongBookFailure(type: SongBookFailureTypes.InvalidParams);
  }

  factory SongBookFailure.serverError({@required ErrorContent errorContent}) {
    return SongBookFailure(
      type: SongBookFailureTypes.ServerError,
      details: errorContent,
    );
  }
}

enum SongBookFailureTypes {
  EmptyArtist,
  EmptySongTitle,
  SongNotFound,
  InvalidParams,
  ServerError,
}

class SongBookFailureManager {
  ErrorContent getSongBookErrorContent(SongBookFailure failure) {
    var _msg = "";
    var _mustBeTranslated = true;
    var _errorCode = 0;

    switch (failure.type) {
      case SongBookFailureTypes.InvalidParams:
        _msg = "song_book.pages.search.errors.invalidParams";
        break;

      case SongBookFailureTypes.EmptyArtist:
        _msg = "song_book.fields.artist.errors.empty";
        break;

      case SongBookFailureTypes.EmptySongTitle:
        _msg = "song_book.fields.song.errors.empty";
        break;

      case SongBookFailureTypes.SongNotFound:
        _msg = "song_book.pages.search.errors.song_not_found";
        break;

      case SongBookFailureTypes.ServerError:
        _msg = "song_book.pages.search.errors.server_error";
        break;
    }

    return ErrorContent(
      errorCode: _errorCode,
      message: _msg,
      mustBeTranslated: _mustBeTranslated,
    );
  }
}
