import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import 'injectable.config.dart';

final GetIt getIt = GetIt.instance;
@injectableInit
Future<void> initConfig() async {
  $initGetIt(getIt);
}
