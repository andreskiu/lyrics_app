// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

import '../../domain/soon_book/usecases/get_lyrics_use_case.dart';
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
  gh.lazySingleton<SongBookService>(() => SongBookServiceImpl());
  gh.lazySingleton<GetLyricsUseCase>(
      () => GetLyricsUseCase(get<SongBookService>()));
  gh.lazySingleton<SongBookState>(
      () => SongBookState(getLyricsUseCase: get<GetLyricsUseCase>()));
  return get;
}
