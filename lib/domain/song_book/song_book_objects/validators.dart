import 'package:dartz/dartz.dart';
import '../failures/song_book_failures.dart';

Either<SongBookFailure, String> validateSongName(String input) {
  if (input == null || input.isEmpty) {
    return Left(SongBookFailure.emptySongTitle());
  }
  return Right(input);
}

Either<SongBookFailure, String> validateArtistName(String input) {
  if (input == null || input.isEmpty) {
    return Left(SongBookFailure.emptyArtist());
  }
  return Right(input);
}
