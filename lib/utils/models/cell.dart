// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'package:devotionals/utils/models/models.dart';

class CellModel {
  dynamic id;
  String name;
  String location;
  List<User> members;
  User?  leader;
  
  CellModel({
    this.id,
    required this.name,
    required this.location,
    this.members = const [],
    this.leader,
  });

  


  CellModel copyWith({
    dynamic id,
    String? name,
    String? location,
    List<User>? members,
    User? leader,
  }) {
    return CellModel(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      members: members ?? this.members,
      leader: leader ?? this.leader,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'location': location,
      'members': members.map((x) => x.toMap()).toList(),
      'leader': leader?.toMap(),
    };
  }

  factory CellModel.fromMap(Map<String, dynamic> map) {
    return CellModel(
      id: map['id'] as dynamic,
      name: map['name'] as String,
      location: map['location'] as String,
      members: List<User>.from((map['members'] as List).map<User>((x) => User.fromMap(x as Map<String,dynamic>),),),
      leader: map['leader'] != null ? User.fromMap(map['leader'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory CellModel.fromJson(String source) => CellModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CellModel(id: $id, name: $name, location: $location, members: $members, leader: $leader)';
  }

  @override
  bool operator ==(covariant CellModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      location.hashCode ^
      members.hashCode ^
      leader.hashCode;
  }
}
