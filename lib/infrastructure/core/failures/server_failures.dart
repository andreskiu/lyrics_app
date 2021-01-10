import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../../domain/core/failures.dart';

abstract class InfrastructureFailure extends Failure {}

class ServerFailure extends Failure<ServerFailureTypes> with EquatableMixin {
  @override
  ServerFailureTypes type;
  ErrorContent details;

  ServerFailure({
    @required this.type,
    this.details,
  });

  @override
  List<Object> get props => [
        type,
        details,
      ];
  factory ServerFailure.cacheError({ErrorContent details}) {
    return ServerFailure(
      type: ServerFailureTypes.Cache,
      details: details,
    );
  }
  factory ServerFailure.notFound({ErrorContent details}) {
    return ServerFailure(
      type: ServerFailureTypes.NotFound,
      details: details,
    );
  }
  factory ServerFailure.connectionError({ErrorContent details}) {
    return ServerFailure(
      type: ServerFailureTypes.ConnectionError,
      details: details,
    );
  }
  factory ServerFailure.badRequest({ErrorContent details}) {
    return ServerFailure(
      type: ServerFailureTypes.BadRequest,
      details: details,
    );
  }
  factory ServerFailure.timeOut({ErrorContent details}) {
    return ServerFailure(
      type: ServerFailureTypes.TimeOut,
      details: details,
    );
  }
  factory ServerFailure.unauthorized({ErrorContent details}) {
    return ServerFailure(
      type: ServerFailureTypes.Unauthorized,
      details: details,
    );
  }
  factory ServerFailure.general({ErrorContent details}) {
    return ServerFailure(
      type: ServerFailureTypes.General,
      details: details,
    );
  }
  factory ServerFailure.formatFailure({ErrorContent details}) {
    return ServerFailure(
      type: ServerFailureTypes.FormatFailure,
      details: details,
    );
  }
}

enum ServerFailureTypes {
  ConnectionError,
  BadRequest,
  Unauthorized,
  NotFound,
  FormatFailure,
  TimeOut,
  Cache,
  General
}

class ServerFailureManager {
  ErrorContent getServerError(ServerFailure failure) {
    var _msg = "";
    var _mustBeTranslated = true;
    var _errorCode = 0;
    switch (failure.type) {
      case ServerFailureTypes.ConnectionError:
        _msg = "infrastructure.errors.connection";
        break;
      case ServerFailureTypes.BadRequest:
        _mustBeTranslated = false;
        _errorCode = failure.details.errorCode;
        _msg = failure.details.message;
        break;
      case ServerFailureTypes.Unauthorized:
        _msg = "infrastructure.errors.unauthorized";
        break;
      case ServerFailureTypes.NotFound:
        _msg = "infrastructure.errors.notFound";
        break;
      case ServerFailureTypes.TimeOut:
        _msg = "infrastructure.errors.timeOut";
        break;
      case ServerFailureTypes.Cache:
        _msg = "infrastructure.errors.cache";
        break;
      default:
        _msg = "infrastructure.errors.general";
        break;
    }

    return ErrorContent(
      errorCode: _errorCode,
      message: _msg,
      mustBeTranslated: _mustBeTranslated,
    );
  }
}
