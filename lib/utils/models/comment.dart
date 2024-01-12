// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:devotionals/utils/models/models.dart';

class CommentModel {
  dynamic id;
  String comment;
  User user;
  DateTime date;

  CommentModel({
    required this.id,
    required this.comment,
    required this.user,
    required this.date,
  });
  

  CommentModel copyWith({
    dynamic? id,
    String? comment,
    User? user,
    DateTime? date,
  }) {
    return CommentModel(
      id: id ?? this.id,
      comment: comment ?? this.comment,
      user: user ?? this.user,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'comment': comment,
      'user': user.toMap(),
      'date': date.millisecondsSinceEpoch,
    };
  }

  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] as dynamic,
      comment: map['comment'] as String,
      user: User.fromMap(map['user'] as Map<String,dynamic>),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory CommentModel.fromJson(String source) => CommentModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'CommentModel(id: $id, comment: $comment, user: $user, date: $date)';
  }

  @override
  bool operator ==(covariant CommentModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.id == id &&
      other.comment == comment &&
      other.user == user &&
      other.date == date;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      comment.hashCode ^
      user.hashCode ^
      date.hashCode;
  }
}
