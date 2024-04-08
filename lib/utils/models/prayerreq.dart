// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:collection/collection.dart';

import 'user.dart';

class PrayerRequest {
  dynamic id;
  User user;
  DateTime date;
  String request;
  String title;
  bool waiting;
  List views;

  PrayerRequest({
    required this.id,
    required this.user,
    required this.date,
    required this.request,
    required this.title,
    this.waiting = true,
    this.views = const [],
  });


  PrayerRequest copyWith({
    dynamic? id,
    User? user,
    DateTime? date,
    String? request,
    String? title,
    bool? waiting,
    List? views,
  }) {
    return PrayerRequest(
      id: id ?? this.id,
      user: user ?? this.user,
      date: date ?? this.date,
      request: request ?? this.request,
      title: title ?? this.title,
      waiting: waiting ?? this.waiting,
      views: views ?? this.views,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'user': user.toMap(),
      'date': date.millisecondsSinceEpoch,
      'request': request,
      'title': title,
      'waiting': waiting,
      'views': views,
    };
  }

  factory PrayerRequest.fromMap(Map<String, dynamic> map) {
    return PrayerRequest(
      id: map['id'] as dynamic,
      user: User.fromMap(map['user'] as Map<String,dynamic>),
      date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
      request: map['request'] as String,
      title: map['title'] as String,
      waiting: map['waiting'] as bool,
      views: List.from((map['views'] as List)),
    );
  }

  String toJson() => json.encode(toMap());

  factory PrayerRequest.fromJson(String source) => PrayerRequest.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'PrayerRequest(id: $id, user: $user, date: $date, request: $request, title: $title, waiting: $waiting, views: $views)';
  }

  @override
  bool operator ==(covariant PrayerRequest other) {
    if (identical(this, other)) return true;
    final listEquals = const DeepCollectionEquality().equals;
  
    return 
      other.id == id &&
      other.user == user &&
      other.date == date &&
      other.request == request &&
      other.title == title &&
      other.waiting == waiting &&
      listEquals(other.views, views);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      user.hashCode ^
      date.hashCode ^
      request.hashCode ^
      title.hashCode ^
      waiting.hashCode ^
      views.hashCode;
  }
}
