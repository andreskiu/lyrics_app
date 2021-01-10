import 'package:dio/native_imp.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../../../domain/core/failures.dart';
import '../failures/server_failures.dart';

abstract class Api {
  Api(this.client);

  final Dio client;

  void addInterceptors(InterceptorsWrapper interceptorsWrapper);
}

@Injectable(as: Api)
class ApiImpl extends Api {
  final InterceptorsWrapper interceptorsWrapper;
  final Dio dio;
  ApiImpl({
    @required this.interceptorsWrapper,
    @required this.dio,
  }) : super(dio) {
    addInterceptors(interceptorsWrapper);
  }

  @override
  void addInterceptors(InterceptorsWrapper interceptorsWrapper) {
    client.interceptors.add(interceptorsWrapper);
  }
}

@Injectable(as: Dio)
class MyDio extends DioForNative {
  BaseOptions baseOptions;
  MyDio({@required this.baseOptions}) : super(baseOptions);
}

// @Injectable(as: InterceptorsWrapper, env: [EnvironmentConfig.demo])
// class DemoInterceptorsWrapper extends InterceptorsWrapper {
//   DemoInterceptorsWrapper() : super();
// }

@Injectable(as: InterceptorsWrapper)
class AppInterceptorsWrapper extends InterceptorsWrapper {
  AppInterceptorsWrapper()
      : super(
          onRequest: (options) async {
            return options;
          },
          onError: (DioError error) async {
            if (error.type == DioErrorType.CONNECT_TIMEOUT ||
                error.type == DioErrorType.RECEIVE_TIMEOUT) {
              return ServerFailure.connectionError();
            }

            if (error.type == DioErrorType.RESPONSE) {
              switch (error.response.statusCode) {
                case 400:
                  return ServerFailure.badRequest();
                  break;
                case 401:
                  return ServerFailure.unauthorized();
                  break;
                case 403:
                  return ServerFailure.unauthorized();
                  break;
                case 404:
                  return ServerFailure.notFound(
                      details: ErrorContent(
                    errorCode: 404,
                    message: error.response.data['error'],
                  ));
                  break;
                default:
                  return ServerFailure.general();
              }
            }
            return ServerFailure.general();
          },
        );
}
