// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:devotionals/utils/models/models.dart';

class CommentModel {
  dynamic id;
  String comment;
  User? repliedUser;
  User user;
  DateTime date;
  List<String> dislikes;
  List<String> likes;
  List<CommentModel> replies;

  CommentModel({
    required this.id,
    required this.comment,
    this.repliedUser,
    required this.user,
    required this.date,
    this.dislikes = const [],
    this.likes = const [],
    this.replies = const[],
  });
  

  CommentModel copyWith({
    dynamic? id,
    String? comment,
    User? repliedUser,
    User? user,
    DateTime? date,
    List<String>? dislikes,
    List<String>? likes,
    List<CommentModel>? replies,
  }) {
    return CommentModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      repliedUser: repliedUser ?? this.repliedUser,
      user: user ?? this.user,
      date: date ?? this.date,
      dislikes: dislikes ?? this.dislikes,
      likes: likes ?? this.likes,
      replies: replies ?? this.replies,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'comment': comment,
      'repliedUser': repliedUser?.toMap(),
      'user': user.toMap(),
      'date': date.millisecondsSinceEpoch,
      'dislikes': dislikes,
      'likes': likes,
      'replies': replies.map((x) => x.toMap()).toList(),
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as dynamic,
      comment: map['comment'].toString(),
      repliedUser: map.containsKey('repliedUser') && map['repliedUser'] != null ? User.fromMap(map['repliedUser'] as Map<String,dynamic>):null,
      user: User.fromMap(map['user'] as Map<String,dynamic>),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      dislikes: List<String>.from((map['dislikes'].toList())),
      likes: List<String>.from((map['likes'].toList())),
      replies: List<CommentModel>.from((map['replies'] as List).map<CommentModel>((x) => CommentModel.fromMap(x as Map<String,dynamic>),),),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, comment: $comment, repliedUser: $repliedUser, user: $user, date: $date, dislikes: $dislikes, likes: $likes, replies: $replies)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      comment.hashCode ^
      repliedUser.hashCode ^
      user.hashCode ^
      date.hashCode ^
      dislikes.hashCode ^
      likes.hashCode ^
      replies.hashCode;
  }
}
