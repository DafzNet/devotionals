// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'package:devotionals/utils/models/user.dart';

class TestimonyModel {
  dynamic id;
  String user;
  Timestamp? timestamp;
  String testimony;
  Map<String, dynamic> reactions;
  TestimonyModel({
    required this.id,
    required this.user,
    this.timestamp,
    required this.testimony,
    this.reactions = const {},
  });

  

  

  TestimonyModel copyWith({
    dynamic? id,
    String? user,
    Timestamp? timestamp,
    String? testimony,
    Map<String, dynamic>? reactions,
  }) {
    return TestimonyModel(
      id: id ?? this.id,
      user: user ?? this.user,
      timestamp: timestamp ?? this.timestamp,
      testimony: testimony ?? this.testimony,
      reactions: reactions ?? this.reactions,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user,
      'timestamp': timestamp,
      'testimony': testimony,
      'reactions': reactions,
    };
  }

  factory TestimonyModel.fromMap(Map<String, dynamic> map) {
    return TestimonyModel(
      id: map['id'] as dynamic,
      user: map['user'] as String,
      timestamp: map['timestamp'] != null ? map['timestamp'] : null,
      testimony: map['testimony'] as String,
      reactions: Map<String, dynamic>.from((map['reactions'])),
    );
  }

  String toJson() => json.encode(toMap());

  factory TestimonyModel.fromJson(String source) => TestimonyModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'TestimonyModel(id: $id, user: $user, timestamp: $timestamp, testimony: $testimony, reactions: $reactions)';
  }

  @override
  bool operator ==(covariant TestimonyModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.user == user &&
      other.timestamp == timestamp &&
      other.testimony == testimony &&
      mapEquals(other.reactions, reactions);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      timestamp.hashCode ^
      testimony.hashCode ^
      reactions.hashCode;
  }
}
