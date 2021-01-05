import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

import '../../domain/soon_book/usecases/get_lyrics_use_case.dart';

@lazySingleton
class SongBookState extends ChangeNotifier {
  SongBookState({
    @required this.getLyricsUseCase,
  });

  // injections
  final GetLyricsUseCase getLyricsUseCase;
}
