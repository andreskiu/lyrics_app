import 'dart:convert';

import 'package:equatable/equatable.dart';

class Artist extends Equatable {
  final int id;
  final String name;
  
  Artist({
    this.id,
    this.name,
  });

  @override
  List<Object> get props => [id, name];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  factory Artist.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return Artist(
      id: map['id'],
      name: map['name'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Artist.fromJson(String source) => Artist.fromMap(json.decode(source));
}
