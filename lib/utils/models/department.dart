// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'user.dart';




class DepartmentModel {
  dynamic id;
  String name;
  List<User> members;
  User?  hod;

  DepartmentModel({
    required this.id,
    required this.name,
    this.members = const [],
    this.hod,
  });


  DepartmentModel copyWith({
    dynamic id,
    String? name,
    List<User>? members,
    User? hod,
  }) {
    return DepartmentModel(
      id: id ?? this.id,
      name: name ?? this.name,
      members: members ?? this.members,
      hod: hod ?? this.hod,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'members': members.map((x) => x.toMap()).toList(),
      'hod': hod?.toMap(),
    };
  }

  factory DepartmentModel.fromMap(Map<String, dynamic> map) {
    return DepartmentModel(
      id: map['id'] as dynamic,
      name: map['name'] as String,
      members: List<User>.from((map['members'] as List).map<User>((x) => User.fromMap(x as Map<String,dynamic>),),),
      hod: map['hod'] != null ? User.fromMap(map['hod'] as Map<String,dynamic>) : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DepartmentModel.fromJson(String source) => DepartmentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'DepartmentModel(id: $id, name: $name, members: $members, hod: $hod)';
  }

  @override
  bool operator ==(covariant DepartmentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      members.hashCode ^
      hod.hashCode;
  }
}
