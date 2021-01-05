import 'package:equatable/equatable.dart';

abstract class Failure<T> {
  T get type;
}

class ErrorContent extends Equatable {
  final String message;
  final bool mustBeTranslated;
  final int errorCode;

  const ErrorContent({
    this.message = "",
    this.mustBeTranslated = true,
    this.errorCode = 0,
  });

  @override
  List<Object> get props => [
        message,
        mustBeTranslated,
        errorCode,
      ];
}