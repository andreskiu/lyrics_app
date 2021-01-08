import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injectable.config.dart';

final GetIt getIt = GetIt.instance;
@injectableInit
Future<void> initConfig() async {
  await _manualInitializations();
  $initGetIt(getIt);
}

Future<void> _manualInitializations() async {
  final _sharedPreferences = await SharedPreferences.getInstance();
  GetIt.I.registerSingleton(_sharedPreferences);

  final _dio = Dio();
  GetIt.I.registerSingleton(_dio);
}
