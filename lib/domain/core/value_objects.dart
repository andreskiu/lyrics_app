import 'package:dartz/dartz.dart';

import 'failures.dart';

abstract class ValueObject<T> {
  const ValueObject();

  Either<Failure, T> get value;

  bool isValid() => value.isRight();

  T getValue() => value?.getOrElse(() => null);

  Failure getError() => value.fold((l) => l, (_) => null);
}

