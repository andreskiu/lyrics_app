import 'package:dio/dio.dart';
import '../failures/server_failures.dart';

abstract class DioErrorManagerMixin {
  ServerFailure manageDioError(DioError e) {
    if (e.error is ServerFailure) {
      return e.error;
    }
    return ServerFailure.general();
  }
}
