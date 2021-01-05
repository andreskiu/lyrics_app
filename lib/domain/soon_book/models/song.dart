import 'package:equatable/equatable.dart';

import 'artist.dart';

class Song extends Equatable {
  final int id;
  final String name;
  final String lyrics;
  final Artist artist;
  
  Song({
    this.id,
    this.name,
    this.lyrics,
    this.artist,
  });

  @override
  List<Object> get props => [id,name,lyrics,artist];
}
