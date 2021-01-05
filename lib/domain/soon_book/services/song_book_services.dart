import 'package:dartz/dartz.dart';
import '../models/song.dart';
import '../../../infrastructure/core/failures/server_failures.dart';

abstract class SongBookService {

  Future<Either<ServerFailure, Song>> getLyrics();
}
