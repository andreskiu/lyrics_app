import 'dart:convert';

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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'lyrics': lyrics,
      'artist': artist?.toMap(),
    };
  }

  factory Song.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Song(
      id: map['id'],
      name: map['name'],
      lyrics: map['lyrics'],
      artist: Artist.fromMap(map['artist']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Song.fromJson(String source) => Song.fromMap(json.decode(source));
}
