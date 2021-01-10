import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: BaseOptions)
class DevBaseOptions extends BaseOptions {
  DevBaseOptions()
      : super(
          baseUrl: "https://api.lyrics.ovh/v1",
          receiveTimeout: 5000,
          connectTimeout: 5000,
        );
}
