import 'package:equatable/equatable.dart';
import '../../../domain/soon_book/services/song_book_services.dart';

class GetSongLyricsReq extends Equatable {
  final String artist;
  final String title;
  GetSongLyricsReq({this.artist, this.title});

  @override
  List<Object> get props => [artist, title];

  Map<String, dynamic> toMap() {
    return {
      'artist': artist,
      'title': title,
    };
  }

  factory GetSongLyricsReq.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return GetSongLyricsReq(
      artist: map['artist'],
      title: map['title'],
    );
  }

  factory GetSongLyricsReq.fromDataModel(GetSongDataModel getSongDataModel) {
    return GetSongLyricsReq(
      artist: getSongDataModel.artist,
      title: getSongDataModel.song
    );
  }
}
