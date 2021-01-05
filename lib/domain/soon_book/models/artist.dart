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
}
