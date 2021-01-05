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
    return SongBookFailure(type: SongBookFailureTypes.NotFound);
  }

  factory SongBookFailure.empty() {
    return SongBookFailure(type: SongBookFailureTypes.Empty);
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
  Empty,
  NotFound,
  InvalidParams,
  ServerError,
}

class SongBookFailureManager {
  ErrorContent getPasscodeErrorContent(SongBookFailure failure) {
    var _msg = "";
    var _mustBeTranslated = true;
    var _errorCode = 0;

    switch (failure.type) {
      case SongBookFailureTypes.InvalidParams:
        _msg = "songBook.pages.search.errors.invalidParams";
        break;

      case SongBookFailureTypes.Empty:
        _msg = "songBook.pages.search.errors.invalidParams";
        break;

      case SongBookFailureTypes.NotFound:
        _msg = "songBook.pages.search.errors.notFound";
        break;

      case SongBookFailureTypes.ServerError:
        return failure.details;
        break;
    }

    return ErrorContent(
      errorCode: _errorCode,
      message: _msg,
      mustBeTranslated: _mustBeTranslated,
    );
  }
}
