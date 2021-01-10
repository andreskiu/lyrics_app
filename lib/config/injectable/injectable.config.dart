// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../infrastructure/core/api/api.dart';
import '../../infrastructure/core/api/api_configuration.dart';
import '../../domain/soon_book/usecases/get_history_use_case.dart';
import '../../domain/soon_book/usecases/get_lyrics_use_case.dart';
import '../../application/song_book/history_state.dart.dart';
import '../../infrastructure/song_book/interfaces/i_song_book_local_repository.dart';
import '../../infrastructure/song_book/interfaces/i_song_book_remote_repository.dart';
import '../../infrastructure/song_book/repositories/song_book_local_memory_repository_impl.dart';
import '../../infrastructure/song_book/repositories/song_book_local_storage_repository_impl.dart';
import '../../infrastructure/song_book/repositories/song_book_remote_repository_impl.dart';
import '../../domain/soon_book/services/song_book_services.dart';
import '../../infrastructure/song_book/services/song_book_service_impl.dart';
import '../../application/song_book/song_book_state.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

GetIt $initGetIt(
  GetIt get, {
  String environment,
  EnvironmentFilter environmentFilter,
}) {
  final gh = GetItHelper(get, environment, environmentFilter);
  gh.factory<BaseOptions>(() => DevBaseOptions());
  gh.factory<Dio>(() => MyDio(baseOptions: get<BaseOptions>()));
  gh.factoryAsync<HistoryState>(() => HistoryState.init());
  gh.lazySingleton<ISongBookLocalPersistentRepository>(() =>
      SongBookLocalStorageRepositoryImpl(
          sharedPreferences: get<SharedPreferences>()));
  gh.lazySingleton<ISongBookLocalVolatileRepository>(() =>
      SongBookLocalMemoryRepositoryImpl(
          sharedPreferences: get<SharedPreferences>()));
  gh.factory<InterceptorsWrapper>(() => AppInterceptorsWrapper());
  gh.factory<Api>(() => ApiImpl(
      interceptorsWrapper: get<InterceptorsWrapper>(), dio: get<Dio>()));
  gh.lazySingleton<ISongBookRemoteRepository>(
      () => SongBookRemoteRepository(api: get<Api>()));
  gh.lazySingleton<SongBookService>(() => SongBookServiceImpl(
        memory: get<ISongBookLocalVolatileRepository>(),
        localStorage: get<ISongBookLocalPersistentRepository>(),
        server: get<ISongBookRemoteRepository>(),
      ));
  gh.lazySingleton<GetHistoryUseCase>(
      () => GetHistoryUseCase(get<SongBookService>()));
  gh.lazySingleton<GetLyricsUseCase>(
      () => GetLyricsUseCase(get<SongBookService>()));
  gh.lazySingleton<SongBookState>(() => SongBookState(
      getLyricsUseCase: get<GetLyricsUseCase>(),
      getHistoryUseCase: get<GetHistoryUseCase>()));
  return get;
}
